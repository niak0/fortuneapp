import 'package:flutter_test/flutter_test.dart';
import 'package:fortuneapp/features/biorhythm/enum/biorhythm_items.dart';

void main() {
  group('Biyoritim döngüleri', () {
    test('6 döngü ve doğru periyotlar', () {
      expect(BiorhythmItems.values.length, 6);
      expect(BiorhythmItems.physical.cycle, 23);
      expect(BiorhythmItems.emotional.cycle, 28);
      expect(BiorhythmItems.intellectual.cycle, 33);
      expect(BiorhythmItems.intuition.cycle, 38);
      expect(BiorhythmItems.aesthetic.cycle, 43);
      expect(BiorhythmItems.spiritual.cycle, 53);
    });

    test('getComment farklı fazlarda farklı metin döndürür', () {
      final low = BiorhythmItems.physical.getComment(10);
      final high = BiorhythmItems.physical.getComment(90);
      expect(low, isNotEmpty);
      expect(high, isNotEmpty);
      expect(low, isNot(high));
    });

    test('kritik gün metni tüm döngüler için tanımlı', () {
      for (final item in BiorhythmItems.values) {
        final critical = item.getComment(50, isCritical: true);
        expect(critical.toLowerCase(), contains('kritik'));
      }
    });
  });
}
