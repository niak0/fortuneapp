import 'package:fortuneapp/core/models/current_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/user_model.dart';
import '../../core/network/mock_service.dart';

part 'profile_edit_view_model.g.dart';

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
    await MockService.updateUserProfile(current.toJson());
    ref.read(currentUserProvider.notifier).updateUser(current);
  }
}
