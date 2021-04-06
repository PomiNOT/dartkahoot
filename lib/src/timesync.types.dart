part of 'timesync.dart';

@JsonSerializable()
class TimesyncClientInfo {
  @JsonKey(required: true)
  int tc;

  @JsonKey(required: true, name: 'l')
  int lag;

  @JsonKey(required: true, name: 'o')
  int offset;

  TimesyncClientInfo(this.tc, this.lag, this.offset);
  factory TimesyncClientInfo.fromJson(Map<String, dynamic> json) =>
      _$TimesyncClientInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TimesyncClientInfoToJson(this);
}

@JsonSerializable()
class TimesyncServerInfo {
  @JsonKey(required: true)
  int tc;

  @JsonKey(required: true)
  int ts;

  @JsonKey(required: true, name: 'p')
  int poll;

  @JsonKey(required: true, name: 'a')
  int accuracy;

  TimesyncServerInfo(this.tc, this.ts, this.poll, this.accuracy);
  factory TimesyncServerInfo.fromJson(Map<String, dynamic> json) =>
      _$TimesyncServerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TimesyncServerInfoToJson(this);
}