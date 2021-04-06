import 'package:dartkahoot/src/client.dart';

Future<void> main(List<String> args) async {
  var pin = int.parse(args[0]);
  var nickname = args[1];
  print('Connecting...');
  var k = KahootClient(pin, nickname);
  await Future.delayed(Duration(seconds: 1));
  await k.joinGame();
}
