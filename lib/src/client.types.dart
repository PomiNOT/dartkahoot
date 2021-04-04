part of 'client.dart';

@JsonSerializable()
class GameInfo {
  @JsonKey(required: true)
  String challenge;

  @JsonKey(required: true)
  bool namerator;

  @JsonKey(required: true)
  bool participantId;

  @JsonKey(required: true)
  bool smartPractice;

  @JsonKey(required: true)
  bool twoFactorAuth;

  @JsonKey(ignore: true)
  String? sessionToken;

  GameInfo(this.challenge, this.namerator, this.participantId,
      this.smartPractice, this.twoFactorAuth);
  factory GameInfo.fromJson(Map<String, dynamic> json) =>
      _$GameInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GameInfoToJson(this);
}

enum RestErrorStatus { KAHOOT_NOT_FOUND, KAHOOT_SLOW_DOWN }

class KahootRestErrorStatus implements Exception {
  RestErrorStatus status;
  KahootRestErrorStatus(this.status);
}
