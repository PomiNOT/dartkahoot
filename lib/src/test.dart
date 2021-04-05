import 'package:dartkahoot/src/client.dart';

Future<void> main() async {
  var pin = 4628755;
  var k = KahootClient(pin, 'yourCliet3');
  await Future.delayed(Duration(seconds: 1));
  await k.joinGame();
}
