import 'dart:async';
import 'dart:convert';
import 'package:dartkahoot/src/extension.dart';
import 'package:web_socket_channel/io.dart';

class BayeuxWSClient {
  final String server;
  int _id = 0;
  String _clientId = '';

  Map<String, List<void Function(dynamic)>> subscribers = {};
  void Function()? onConnect;
  void Function()? onDisconnect;
  Timer? _pingTimer;

  Map<String, BayeuxExtension>? extensions = {};

  late IOWebSocketChannel _client;

  BayeuxWSClient(this.server,
      {this.onConnect, this.onDisconnect, this.extensions}) {
    _client = IOWebSocketChannel.connect(Uri.parse(server));
    _client.stream.listen((message) => _handleWSMessage(message));

    subscribe('/meta/handshake', (m) {
      if (m['successful']) {
        _clientId = m['clientId'];
        _pingTimer = Timer.periodic(Duration(seconds: 15), (_) => _ping());

        if (onConnect != null) {
          onConnect!();
        }
      }
    });

    subscribe('/meta/connect', (m) {
      if (!m['successful'] && _pingTimer != null) {
        _pingTimer!.cancel();
      }
    });

    subscribe('/meta/disconnect', (m) {
      if (m['successful']) {
        if (onDisconnect != null) {
          onDisconnect!();
        }

        if (_pingTimer != null) {
          _pingTimer!.cancel();
        }

        _client.sink.close();
      }
    });

    _handshake();
  }

  void subscribe(String channel, void Function(dynamic) callback) {
    subscribers[channel] ??= [];
    subscribers[channel]!.add(callback);
  }

  void publish(String channel, dynamic data) {
    _sendToChannel(channel, {'data': data, 'clientId': _clientId});
  }

  void disconnect() {
    _sendToChannel('/meta/disconnect', {'clientId': _clientId});
  }

  void _handleWSMessage(String message) {
    dynamic m = jsonDecode(message)[0];

    if (extensions != null && m['ext'] != null) {
      m['ext'].forEach((name, response) {
        extensions![name]?.onReceive(response);
      });
    }

    if (subscribers.containsKey(m['channel'])) {
      for (var cb in subscribers[m['channel']]!) {
        cb(m);
      }
    }
  }

  void _sendToChannel(String channel, Map<String, dynamic> object) {
    _id++;

    var data = {
      'id': _id,
      'channel': channel,
      ...object,
      'ext': _getExtensionData()
    };

    _client.sink.add(jsonEncode([data]));
  }

  Map<String, Map<String, dynamic>> _getExtensionData() {
    // ignore: omit_local_variable_types
    Map<String, Map<String, dynamic>> result = {};

    if (extensions != null) {
      extensions!.forEach((name, ext) {
        result[name] = ext.onSend();
      });
    }

    return result;
  }

  void _handshake() {
    _sendToChannel('/meta/handshake', {
      'advice': {'timeout': 60000, 'interval': 0},
      'minimumVersion': '1.0',
      'supportedConnectionTypes': ['websocket'],
      'version': '1.0'
    });
  }

  void _ping() {
    _sendToChannel('/meta/connect', {
      'advice': {
        'timeout': 0,
      },
      'clientId': _clientId,
      'connectionType': 'websocket'
    });
  }
}
