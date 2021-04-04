import 'dart:convert';

import 'package:web_socket_channel/io.dart';

class BayeuxWSClient {
  final String _server;

  int _id = 0;
  String _clientId = '';
  Map<String, List<void Function(dynamic)>> subscribers = {};

  late Stream _pingStream;
  late IOWebSocketChannel _client;

  BayeuxWSClient(this._server) {
    _client = IOWebSocketChannel.connect(Uri.parse(_server));
    _client.stream.listen((message) => _handleWSMessage(message));

    subscribe('/meta/handshake', (m) {
      if (m['successful']) {
        _clientId = m['clientId'];
        _pingStream = Stream.periodic(Duration(seconds: 15));
        _pingStream.listen((_) => _ping());
      }
    });

    _handshake();
  }

  void subscribe(String channel, void Function(dynamic) callback) {
    if (!subscribers.containsKey(channel)) {
      subscribers[channel] = [];
    }

    subscribers[channel]!.add(callback);
  }

  void publish(String channel, dynamic data) {
    _sendToChannel(channel, {
      'data': data,
      'clientId': _clientId
    });
  }

  void _handleWSMessage(String message) {
    print(message);

    dynamic m = jsonDecode(message)[0];

    if (subscribers.containsKey(m['channel'])) {
      for (var cb in subscribers[m['channel']]!) {
        cb(m);
      }
    }
  }

  void _sendToChannel(String channel, Map<String, dynamic> object) {
    _id++;

    _client.sink.add(jsonEncode([
      {'id': _id, 'channel': channel, ...object}
    ]));
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
