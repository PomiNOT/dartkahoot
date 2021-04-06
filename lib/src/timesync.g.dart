// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesync.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesyncClientInfo _$TimesyncClientInfoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['tc', 'l', 'o']);
  return TimesyncClientInfo(
    json['tc'] as int,
    json['l'] as int,
    json['o'] as int,
  );
}

Map<String, dynamic> _$TimesyncClientInfoToJson(TimesyncClientInfo instance) =>
    <String, dynamic>{
      'tc': instance.tc,
      'l': instance.lag,
      'o': instance.offset,
    };

TimesyncServerInfo _$TimesyncServerInfoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['tc', 'ts', 'p', 'a']);
  return TimesyncServerInfo(
    json['tc'] as int,
    json['ts'] as int,
    json['p'] as int,
    json['a'] as int,
  );
}

Map<String, dynamic> _$TimesyncServerInfoToJson(TimesyncServerInfo instance) =>
    <String, dynamic>{
      'tc': instance.tc,
      'ts': instance.ts,
      'p': instance.poll,
      'a': instance.accuracy,
    };
