import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/data/fortune_repository.dart';
import '../../core/models/fortune_model.dart';

part 'home_providers.g.dart';

// Anasayfada gösterilen son falları (okunmamış/erişilemez) yayınlar.
@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Stream<List<FortuneModel>> build() {
    final repo = ref.watch(fortuneRepositoryProvider);
    // Stream hatası AsyncValue.error olarak yüzeye çıkar; sessizce yutulmaz.
    return repo.watchAll().map((fortunes) {
      return fortunes.where((fortune) {
        final isUnread = !(fortune.isRead ?? true);
        final isNotAccessible = !(fortune.isAccessible ?? true);
        return isNotAccessible || isUnread;
      }).toList();
    });
  }

  // Falı erişilebilir hale getirir (mock).
  Future<void> makeFortuneAccessible(String fortuneId) =>
      ref.read(fortuneRepositoryProvider).setAccess(fortuneId);

  // Falı okundu olarak işaretler.
  Future<void> markAsRead(String fortuneId) =>
      ref.read(fortuneRepositoryProvider).markAsRead(fortuneId);

  // Hedef saate kalan süreyi hesaplar.
  Duration calculateRemainingTimes(DateTime unlockTime) {
    final now = DateTime.now();
    return unlockTime.isAfter(now) ? unlockTime.difference(now) : Duration.zero;
  }
}
