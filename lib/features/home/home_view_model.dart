import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fortuneapp/core/network/mock_firebase_service.dart';
import '../../core/models/fortune_model.dart';

class HomeViewModel with ChangeNotifier {
  final MockFirebaseService _firebaseService = MockFirebaseService();

  Future<void> makeFortuneAccessible(String fortuneId) async {
    await _firebaseService.setFortuneAccess(fortuneId);
    notifyListeners();
  }

  Stream<List<ContentModel>> get recentFortunesStream {
    return _firebaseService.getUserFortunesStream().map((fortunes) {
      final recentFortunes = (fortunes).where((fortune) {
        final isUnread = !(fortune.isRead ?? true);
        final isNotAccessible = !(fortune.isAccessible ?? true);
        return isNotAccessible || isUnread;
      }).toList();

      return recentFortunes;
    }).handleError((error) {
      // Hata durumunu loglayın veya gerektiğinde boş liste döndürün.
      if (kDebugMode) {
        print("Stream error: $error");
      }
      return <ContentModel>[]; // Hata durumunda boş bir liste döndür.
    });
  }

  Duration calculateRemainingTimes(DateTime unlockTime) {
    final now = DateTime.now();
    return unlockTime.isAfter(now) ? unlockTime.difference(now) : Duration.zero;
  }

  Future<void> markAsRead(String fortuneId) async {
    await _firebaseService.markAsRead(fortuneId);
  }
}
