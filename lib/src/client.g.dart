// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameInfo _$GameInfoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const [
    'challenge',
    'namerator',
    'participantId',
    'smartPractice',
    'twoFactorAuth'
  ]);
  return GameInfo(
    json['challenge'] as String,
    json['namerator'] as bool,
    json['participantId'] as bool,
    json['smartPractice'] as bool,
    json['twoFactorAuth'] as bool,
  );
}

Map<String, dynamic> _$GameInfoToJson(GameInfo instance) => <String, dynamic>{
      'challenge': instance.challenge,
      'namerator': instance.namerator,
      'participantId': instance.participantId,
      'smartPractice': instance.smartPractice,
      'twoFactorAuth': instance.twoFactorAuth,
    };
