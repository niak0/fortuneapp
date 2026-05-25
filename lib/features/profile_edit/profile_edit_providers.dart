import 'package:fortuneapp/core/auth/current_user.dart';
import 'package:fortuneapp/core/data/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/user_model.dart';

part 'profile_edit_providers.g.dart';

// Profil düzenleme ekranının geçici (uncommitted) state'ini tutar.
@riverpod
class ProfileEditViewModel extends _$ProfileEditViewModel {
  @override
  UserModel? build() {
    final current = ref.watch(currentUserProvider).value;
    return current;
  }

  // UserModel alanlarını günceller.
  void updateUser({
    String? name,
    DateTime? birthDate,
    String? location,
    String? zodiacSign,
    String? gender,
    String? workState,
    String? relationShipState,
  }) {
    final current = state;
    if (current == null) return;
    state = current.copyWith(
      name: name,
      birthDate: birthDate,
      location: location,
      zodiacSign: zodiacSign,
      gender: gender,
      workState: workState,
      relationShipState: relationShipState,
    );
  }

  // Değişiklikleri mock servise yazar ve CurrentUser'ı tazeler.
  Future<void> saveUserChanges() async {
    final current = state;
    if (current == null) return;
    await ref.read(userRepositoryProvider).update(current);
    ref.read(currentUserProvider.notifier).updateUser(current);
  }
}
