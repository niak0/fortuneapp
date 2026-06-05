import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuneapp/core/models/fortune_model.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';

void main() {
  group('FortuneModel.fromJson', () {
    test('Timestamp ve enum string\'lerini doğru çözer', () {
      final json = {
        'fortune': 'metin',
        'fortuneType': 'tarot',
        'fortuneTopic': 'love',
        'createdTime': Timestamp.fromDate(DateTime(2026, 6, 5, 14, 30)),
        'unlockTime': Timestamp.fromDate(DateTime(2026, 6, 5, 14, 30)),
        'isRead': true,
        'isAccessible': false,
        'userId': 'u1',
      };

      final model = FortuneModel.fromJson(json);

      expect(model.fortuneType, ContentType.tarot);
      expect(model.fortuneTopic, FortuneTopic.love);
      expect(model.createdTime, DateTime(2026, 6, 5, 14, 30));
      expect(model.isRead, true);
      expect(model.isAccessible, false);
    });

    test('bilinmeyen enum değeri crash etmez, null döner', () {
      final json = {
        'fortune': 'metin',
        'fortuneType': 'astrology',
        'fortuneTopic': 'bilinmeyen',
        'isRead': false,
        'isAccessible': true,
      };

      final model = FortuneModel.fromJson(json);

      expect(model.fortuneType, isNull);
      expect(model.fortuneTopic, isNull);
    });

    test('ISO string timestamp da kabul edilir', () {
      final json = {
        'fortune': 'metin',
        'fortuneType': 'coffee',
        'createdTime': '2026-06-05T14:30:00.000',
      };

      final model = FortuneModel.fromJson(json);

      expect(model.createdTime, DateTime(2026, 6, 5, 14, 30));
    });
  });
}
