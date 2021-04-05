import 'package:dartkahoot/src/bayeux.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'token.dart';

part 'client.g.dart';
part 'client.types.dart';

class KahootClient {
  final int pin;
  String name;
  late BayeuxWSClient _client;

  KahootClient(this.pin, this.name);

  Future<GameInfo> _checkGame() async {
    var kahootServer = Uri.parse(
        'https://kahoot.it/reserve/session/$pin/?${DateTime.now().millisecondsSinceEpoch}');

    var response = await http.get(kahootServer);

    if (response.statusCode == 404) {
      throw KahootRestErrorStatus(RestErrorStatus.KAHOOT_NOT_FOUND);
    } else if (response.statusCode == 503) {
      throw KahootRestErrorStatus(RestErrorStatus.KAHOOT_SLOW_DOWN);
    }

    var info = GameInfo.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    info.sessionToken = response.headers['x-kahoot-session-token'];

    return info;
  }

  Future<void> _login() async {
    _client.publish('/service/controller', {
      'content':
          '{"device":{"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.114 Safari/537.36","screen":{"width":1366,"height":768}}}',
      'gameid': pin.toString(),
      'host': 'kahoot.it',
      'name': name,
      'type': 'login'
    });
  }

  Future<void> joinGame() async {
    var gameInfo = await _checkGame();

    var token = decodeToken(
        extractChallenge(gameInfo.challenge, gameInfo.sessionToken!));

    _client =
        BayeuxWSClient('wss://kahoot.it/cometd/$pin/$token', onConnect: () {
      _login();
    });
  }

  void exitGame() {
    _client.disconnect();
  }
}
