import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/astrology/zodiac/zodiac_data.dart';
import '../../features/astrology/zodiac/zodiac_model.dart';

part 'zodiac_repository.g.dart';

// Burç verilerine erişim için abstract interface.
abstract class ZodiacRepository {
  Future<List<ZodiacModel>> fetchAll();
}

// Bundle içindeki statik referans veriden çalışan implementasyon.
class LocalZodiacRepository implements ZodiacRepository {
  @override
  Future<List<ZodiacModel>> fetchAll() async {
    return zodiacReferenceData
        .map(
          (json) => ZodiacModel(
            sign: json['sign'],
            planet: json['planet'],
            element: json['element'],
            dateRange: json['dateRange'],
            loveScore: json['loveScore'],
            healthScore: json['healthScore'],
            moneyScore: json['moneyScore'],
            motto: json['motto'],
            commentYesterday: json['commentYesterday'],
            commentDaily: json['commentDaily'],
            commentWeekly: json['commentWeekly'],
            commentMonthly: json['commentMonthly'],
            commentYearly: json['commentYearly'],
          ),
        )
        .toList();
  }
}

// ZodiacRepository DI provider'ı.
@Riverpod(keepAlive: true)
ZodiacRepository zodiacRepository(Ref ref) => LocalZodiacRepository();
