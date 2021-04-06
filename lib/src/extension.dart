abstract class BayeuxExtension {
  Map<String, dynamic> onSend();
  void onReceive(Map<String, dynamic> data);
}
