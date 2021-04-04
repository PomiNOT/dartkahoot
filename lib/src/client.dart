import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'token.dart';

part 'client.g.dart';
part 'client.types.dart';

class KahootClient {
  final int pin;

  KahootClient(this.pin);

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

  Future<String> joinGame() async {
    var gameInfo = await _checkGame();

    if (gameInfo.sessionToken == null) throw Exception('Session Token is null');

    var token = decodeToken(
        extractChallenge(gameInfo.challenge, gameInfo.sessionToken!));

    return token;
  }
}
