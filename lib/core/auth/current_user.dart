import 'package:fortuneapp/core/data/user_repository.dart';
import 'package:fortuneapp/core/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_bootstrap.dart';

part 'current_user.g.dart';

// Uygulama boyunca aktif kullanıcı state'i (Riverpod AsyncNotifier).
// Auth state (uid) değişince profil otomatik yeniden yüklenir.
@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  Future<UserModel?> build() async {
    ref.watch(authStateChangesProvider);
    return ref.read(userRepositoryProvider).fetchCurrent();
  }

  // Kullanıcıyı tamamen değiştirir.
  void updateUser(UserModel user) {
    state = AsyncData(user);
  }

  // Mevcut kullanıcıya altın ekler.
  void incrementGold({required int amount}) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(coin: current.coin + amount));
  }

  // Mevcut kullanıcının altınını azaltır.
  void decrementGold(int amount) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(coin: current.coin - amount));
  }

  // Oturumu kapatır, kullanıcıyı temizler.
  void clearUser() {
    state = const AsyncData(null);
  }
}
