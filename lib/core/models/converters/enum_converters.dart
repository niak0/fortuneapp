import 'package:json_annotation/json_annotation.dart';

import '../../../enums/fortune_topic.dart';
import '../../../enums/gpt_content_type.dart';

// Fal türünü string '.name' ile saklar; bilinmeyen değeri null'a düşürür
// (canlı/örnek veride beklenmeyen değer crash etmesin diye toleranslı).
class ContentTypeConverter implements JsonConverter<ContentType?, String?> {
  const ContentTypeConverter();

  @override
  ContentType? fromJson(String? json) =>
      ContentType.values.where((e) => e.name == json).firstOrNull;

  @override
  String? toJson(ContentType? value) => value?.name;
}

// Fal konusunu string '.name' ile saklar; bilinmeyen değeri null'a düşürür.
class FortuneTopicConverter implements JsonConverter<FortuneTopic?, String?> {
  const FortuneTopicConverter();

  @override
  FortuneTopic? fromJson(String? json) =>
      FortuneTopic.values.where((e) => e.name == json).firstOrNull;

  @override
  String? toJson(FortuneTopic? value) => value?.name;
}
