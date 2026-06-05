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
    // Profil yoksa anon kullanıcı için varsayılan profil otomatik oluşturulur;
    // kullanıcı sonradan profil düzenlemeden (CRUD) günceller.
    return ref.read(userRepositoryProvider).fetchOrCreate(_defaultUser);
  }

  // Yeni anon kullanıcı için varsayılan (boş) profil.
  static UserModel _defaultUser() => UserModel(
    name: 'Misafir',
    birthDate: DateTime(2000, 1, 1),
    location: '',
    zodiacSign: '',
    gender: '',
    workState: '',
    relationshipState: '',
  );

  // Kullanıcıyı tamamen değiştirir.
  void updateUser(UserModel user) {
    state = AsyncData(user);
  }

  // Mevcut kullanıcıya altın ekler (optimistic + Firestore'a kalıcı).
  Future<void> incrementGold({required int amount}) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.copyWith(coin: current.coin + amount);
    state = AsyncData(updated);
    try {
      await ref.read(userRepositoryProvider).update(updated);
    } catch (_) {
      if (ref.mounted) state = AsyncData(current);
    }
  }

  // Mevcut kullanıcının altınını azaltır (optimistic + Firestore'a kalıcı).
  Future<void> decrementGold(int amount) async {
    final current = state.value;
    if (current == null || current.coin - amount < 0) return;
    final updated = current.copyWith(coin: current.coin - amount);
    state = AsyncData(updated);
    try {
      await ref.read(userRepositoryProvider).update(updated);
    } catch (_) {
      if (ref.mounted) state = AsyncData(current);
    }
  }

  // Oturumu kapatır, kullanıcıyı temizler.
  void clearUser() {
    state = const AsyncData(null);
  }
}
