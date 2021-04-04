import 'bayeux.dart';
import 'client.dart';

Future<void> main() async {
  var pin = 2620324;
  var k = KahootClient(pin);
  var token = await k.joinGame();

  var c = BayeuxWSClient('wss://kahoot.it/cometd/$pin/$token');

  await Future.delayed(Duration(seconds: 8));

  c.publish('/service/controller', {
    'content': '{"device":{"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.114 Safari/537.36","screen":{"width":1366,"height":768}}}',
    'gameid': pin.toString(),
    'host': 'kahoot.it',
    'name': 'uruafa',
    'type': 'login'
  });
}
