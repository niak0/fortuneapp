// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fortune_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FortuneModel _$FortuneModelFromJson(Map<String, dynamic> json) => FortuneModel(
  createdTime: const TimestampConverter().fromJson(json['createdTime']),
  unlockTime: const TimestampConverter().fromJson(json['unlockTime']),
  fortune: json['fortune'] as String?,
  userId: json['userId'] as String?,
  status: json['status'] as String?,
  fortuneType: const ContentTypeConverter().fromJson(
    json['fortuneType'] as String?,
  ),
  fortuneTopic: const FortuneTopicConverter().fromJson(
    json['fortuneTopic'] as String?,
  ),
  isRead: json['isRead'] as bool? ?? false,
  isAccessible: json['isAccessible'] as bool? ?? false,
);

Map<String, dynamic> _$FortuneModelToJson(
  FortuneModel instance,
) => <String, dynamic>{
  'createdTime': const TimestampConverter().toJson(instance.createdTime),
  'unlockTime': const TimestampConverter().toJson(instance.unlockTime),
  'fortune': instance.fortune,
  'userId': instance.userId,
  'status': instance.status,
  'fortuneType': const ContentTypeConverter().toJson(instance.fortuneType),
  'fortuneTopic': const FortuneTopicConverter().toJson(instance.fortuneTopic),
  'isRead': instance.isRead,
  'isAccessible': instance.isAccessible,
};
