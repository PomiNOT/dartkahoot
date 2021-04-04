import 'dart:convert';

import 'package:math_expressions/math_expressions.dart';

class ChallengeInfo {
  String sessionToken;
  String maskToken;
  String offsetExpression;

  ChallengeInfo(this.sessionToken, this.maskToken, this.offsetExpression);
}

ChallengeInfo extractChallenge(String challengeString, String sessionToken) {
  var maskTokenMatch = RegExp(r"decode\.call\(this, '(.+?)'\);");
  var offsetExpMatch = RegExp(r'var\soffset\s?=\s?(.+?);');

  var maskToken = maskTokenMatch.firstMatch(challengeString).group(1);
  var offsetExpression = offsetExpMatch
      .firstMatch(challengeString)
      .group(1)
      .trim()
      .replaceAll(RegExp(r'\s'), '');

  return ChallengeInfo(sessionToken, maskToken, offsetExpression);
}

String decodeToken(ChallengeInfo info) {
  var p = Parser();
  var exp = p.parse(info.offsetExpression);
  int offset = exp.evaluate(EvaluationType.REAL, ContextModel()).toInt();

  var mask = utf8.encode(info.maskToken);
  for (var i = 0; i < mask.length; i++) {
    mask[i] = ((mask[i] * i + offset) % 77) + 48;
  }

  var sessionTokBytes = base64Decode(info.sessionToken);
  for (var i = 0; i < sessionTokBytes.length; i++) {
    sessionTokBytes[i] ^= mask[i % mask.length];
  }

  return utf8.decode(sessionTokBytes);
}
