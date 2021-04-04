import 'package:dartkahoot/src/token.dart';
import 'package:test/test.dart';

void main() {
  final inputChallenge =
      r"decode.call(this, 'RU7GHxuwIB5COZGoSjStUcUScXlFoy06On0MNyNytPjnn3ZZZEEOsg56V6qPOh07hGgv5JSWb1S4MLmNPsXqy0IjnTlZzYTg6Qbm'); function decode(message) {var offset = (41+32+(49 * 37)) * 59 * 28; if( 	 this. angular   .	 isObject	 (   offset	 )) console 	 . log (`Offset derived as: {`, offset, `}`); return _ 	 . replace ( message,/./g, function(char, position) {return String.fromCharCode((((char.charCodeAt(0)*position)+ offset ) % 77) + 48);});}";
  final expectedToken =
      'b38db0097fa02900e12558893b9dc462e3a204cd017bebf8d688e80c343d151c40be3118bb50975cbb9c23428a3a8555';
  final sessionToken = 'J35eV1MFfg5FGl1Bb20ORT1VVkB+fWMMCRNQCwJFTQNdYzV3WWQIP2lCAARfVFV4KQgOZh0FYhJcd304QVZGJlNwORwFbFluFAoGR3xyUCQsIUVVd3daAUQtZAALXlp+';

  group('Extracting and decoding', () {
    test('Extract a token', () {
      var challengeInfo = extractChallenge(inputChallenge, sessionToken);

      expect(challengeInfo.sessionToken, equals(sessionToken));
      expect(
          challengeInfo.maskToken,
          equals(
              'RU7GHxuwIB5COZGoSjStUcUScXlFoy06On0MNyNytPjnn3ZZZEEOsg56V6qPOh07hGgv5JSWb1S4MLmNPsXqy0IjnTlZzYTg6Qbm'));
      expect(challengeInfo.offsetExpression, equals('(41+32+(49*37))*59*28'));
    });

    test('Decode a token', () {
      var challengeInfo = extractChallenge(inputChallenge, sessionToken);
      var decodedToken = decodeToken(challengeInfo);

      expect(decodedToken, equals(expectedToken));
    });
  });
}
