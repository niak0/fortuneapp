import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:fortuneapp/core/network/mock_firebase_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/fortune_model.dart';

part 'home_view_model.g.dart';

// Anasayfada gösterilen son falları (okunmamış/erişilemez) yayınlar.
@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Stream<List<ContentModel>> build() {
    final service = ref.watch(mockFirebaseServiceProvider);
    return service.getUserFortunesStream().map((fortunes) {
      return fortunes.where((fortune) {
        final isUnread = !(fortune.isRead ?? true);
        final isNotAccessible = !(fortune.isAccessible ?? true);
        return isNotAccessible || isUnread;
      }).toList();
    }).handleError((Object error) {
      if (kDebugMode) print('Stream error: $error');
      return <ContentModel>[];
    });
  }

  // Falı erişilebilir hale getirir (mock).
  Future<void> makeFortuneAccessible(String fortuneId) async {
    final service = ref.read(mockFirebaseServiceProvider);
    await service.setFortuneAccess(fortuneId);
  }

  // Falı okundu olarak işaretler.
  Future<void> markAsRead(String fortuneId) async {
    final service = ref.read(mockFirebaseServiceProvider);
    await service.markAsRead(fortuneId);
  }

  // Hedef saate kalan süreyi hesaplar.
  Duration calculateRemainingTimes(DateTime unlockTime) {
    final now = DateTime.now();
    return unlockTime.isAfter(now) ? unlockTime.difference(now) : Duration.zero;
  }
}
