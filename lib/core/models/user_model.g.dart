// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  name: json['name'] as String,
  birthDate: DateTime.parse(json['birthDate'] as String),
  location: json['location'] as String,
  zodiacSign: json['zodiacSign'] as String,
  gender: UserModel._readGender(json, 'gender') as String,
  workState: json['workState'] as String,
  relationshipState:
      UserModel._readRelationship(json, 'relationshipState') as String,
  coin: (json['coin'] as num?)?.toInt() ?? 3,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'name': instance.name,
  'birthDate': instance.birthDate.toIso8601String(),
  'location': instance.location,
  'zodiacSign': instance.zodiacSign,
  'gender': instance.gender,
  'workState': instance.workState,
  'relationshipState': instance.relationshipState,
  'coin': instance.coin,
  'createdAt': ?instance.createdAt?.toIso8601String(),
  'updatedAt': ?instance.updatedAt?.toIso8601String(),
};
