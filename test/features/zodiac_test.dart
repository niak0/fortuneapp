import 'package:flutter_test/flutter_test.dart';
import 'package:fortuneapp/core/data/zodiac_repository.dart';
import 'package:fortuneapp/features/astrology/zodiac/zodiac_view.dart';

void main() {
  group('Zodiac referans verisi', () {
    test('LocalZodiacRepository 12 burç döndürür', () async {
      final models = await LocalZodiacRepository().fetchAll();
      expect(models.length, 12);
      // Statik alanlar dolu olmalı (gezegen/element/tarih/motto).
      for (final m in models) {
        expect(m.sign, isNotEmpty);
        expect(m.planet, isNotEmpty);
        expect(m.element, isNotEmpty);
        expect(m.dateRange, isNotEmpty);
        expect(m.motto, isNotEmpty);
      }
    });

    test('getComment(day) günlük yorumu döndürür', () async {
      final models = await LocalZodiacRepository().fetchAll();
      final aries = models.firstWhere((m) => m.sign == 'aries');
      expect(aries.getComment(ZodiacSegments.day), aries.commentDaily);
      expect(aries.getComment(ZodiacSegments.week), aries.commentWeekly);
    });
  });
}
