import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/astrology/zodiac/zodiac_data.dart';
import '../../features/astrology/zodiac/zodiac_model.dart';

part 'zodiac_repository.g.dart';

// Burç verilerine erişim için abstract interface.
abstract class ZodiacRepository {
  Future<List<ZodiacModel>> fetchAll();
}

// Statik referans (gezegen/element/...) + opsiyonel günlük overlay'den model üretir.
// [daily] Firestore'dan gelen {love, health, money, comment} haritasıdır.
ZodiacModel _modelFromStatic(
  Map<String, dynamic> json, {
  Map<String, dynamic>? daily,
}) {
  return ZodiacModel(
    sign: json['sign'],
    planet: json['planet'],
    element: json['element'],
    dateRange: json['dateRange'],
    loveScore: (daily?['love'] ?? json['loveScore']) as int,
    healthScore: (daily?['health'] ?? json['healthScore']) as int,
    moneyScore: (daily?['money'] ?? json['moneyScore']) as int,
    motto: json['motto'],
    commentYesterday: json['commentYesterday'],
    commentDaily: (daily?['comment'] as String?) ?? json['commentDaily'],
    commentWeekly: json['commentWeekly'],
    commentMonthly: json['commentMonthly'],
    commentYearly: json['commentYearly'],
  );
}

// Bundle içindeki statik referans veriden çalışan implementasyon (fallback/test).
class LocalZodiacRepository implements ZodiacRepository {
  @override
  Future<List<ZodiacModel>> fetchAll() async {
    return zodiacReferenceData.map(_modelFromStatic).toList();
  }
}

// Statik referansı Firestore'daki günlük burçlarla birleştiren implementasyon.
// Günlük skor/yorum `dailyHoroscopes/current` dokümanından gelir; yoksa statik.
class FirestoreZodiacRepository implements ZodiacRepository {
  FirestoreZodiacRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<List<ZodiacModel>> fetchAll() async {
    Map<String, dynamic> signs = const {};
    try {
      final doc = await _firestore
          .collection('dailyHoroscopes')
          .doc('current')
          .get();
      final data = doc.data();
      if (data != null && data['signs'] is Map) {
        signs = Map<String, dynamic>.from(data['signs'] as Map);
      }
    } catch (e, s) {
      developer.log(
        'Günlük burçlar okunamadı, statiğe düşülüyor',
        name: 'zodiac_repository',
        error: e,
        stackTrace: s,
      );
    }

    return zodiacReferenceData.map((json) {
      final daily = signs[json['sign']];
      return _modelFromStatic(
        json,
        daily: daily is Map ? Map<String, dynamic>.from(daily) : null,
      );
    }).toList();
  }
}

// ZodiacRepository DI provider'ı — günlük veri için Firestore tabanlı.
@Riverpod(keepAlive: true)
ZodiacRepository zodiacRepository(Ref ref) => FirestoreZodiacRepository();
