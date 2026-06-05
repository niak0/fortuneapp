import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/data/fortune_repository.dart';
import '../../core/models/fortune_model.dart';

part 'my_fortunes_providers.g.dart';

// Kullanıcının tüm fal geçmişini stream olarak yayınlar.
@riverpod
class MyFortunesViewModel extends _$MyFortunesViewModel {
  @override
  Stream<List<FortuneModel>> build() {
    return ref.watch(fortuneRepositoryProvider).watchAll();
  }

  // Falı okundu olarak işaretler.
  Future<void> markAsRead(String fortuneId) =>
      ref.read(fortuneRepositoryProvider).markAsRead(fortuneId);

  // Falı erişilebilir hale getirir.
  Future<void> makeFortuneAccessible(String fortuneId) =>
      ref.read(fortuneRepositoryProvider).setAccess(fortuneId);
}
