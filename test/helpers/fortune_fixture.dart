import 'package:fortuneapp/core/models/fortune_model.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';

// Test'lerde tekrar kullanılan örnek FortuneModel üretir.
FortuneModel fortuneFixture({
  String id = 'f1',
  ContentType type = ContentType.coffee,
  FortuneTopic? topic = FortuneTopic.general,
  bool isRead = false,
  bool isAccessible = true,
}) {
  return FortuneModel(
    id: id,
    createdTime: DateTime(2026, 1, 1, 12),
    unlockTime: DateTime(2026, 1, 1, 12),
    fortune: 'örnek fal metni',
    userId: 'u1',
    fortuneType: type,
    fortuneTopic: topic,
    isRead: isRead,
    isAccessible: isAccessible,
  );
}
