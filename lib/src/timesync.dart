import 'package:json_annotation/json_annotation.dart';
import 'package:dartkahoot/src/extension.dart';

part 'timesync.types.dart';
part 'timesync.g.dart';

class TimeSyncExtension extends BayeuxExtension {
  TimesyncClientInfo clientInfo = TimesyncClientInfo(0, 0, 0);

  TimeSyncExtension();

  @override
  Map<String, dynamic> onSend() {
    clientInfo.tc = DateTime.now().millisecondsSinceEpoch;
    return clientInfo.toJson();
  }

  @override
  void onReceive(Map<String, dynamic> data) {
    var serverInfo = TimesyncServerInfo.fromJson(data);
    var now = DateTime.now().millisecondsSinceEpoch;

    clientInfo.lag = ((now - serverInfo.tc - serverInfo.poll) / 2).round();
    clientInfo.offset = serverInfo.ts - serverInfo.tc - clientInfo.lag;
  }
}
