import 'package:flutter/foundation.dart';
import 'package:fortuneapp/core/auth/current_user.dart';
import 'package:fortuneapp/core/data/user_repository.dart';
import 'package:fortuneapp/core/navigation/app_navigator.dart';
import 'package:fortuneapp/core/ui/ui_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'user_setup_state.dart';

export 'user_setup_state.dart';

part 'user_setup_providers.g.dart';

// Çok adımlı kullanıcı kurulum formu için Notifier.
@riverpod
class UserSetupViewModel extends _$UserSetupViewModel {
  @override
  UserSetupState build() => UserSetupState.initial();

  // Hangi adımda olduğumuzu günceller.
  void updateCurrentStep(int index) {
    state = state.copyWith(currentStep: index);
  }

  // Mevcut adımdaki form alanını doğrular.
  bool isStepValid() {
    final user = state.user;
    switch (state.currentStep) {
      case 0:
        if (user.name.length < 3) {
          ref.read(uiHelperProvider).showSnackBar('Lütfen adınızı giriniz.');
          return false;
        }
        break;
      case 1:
        if (user.birthDate.isAtSameMomentAs(DateTime.now())) {
          ref.read(uiHelperProvider).showSnackBar('Lütfen doğru bir tarih giriniz.');
          return false;
        }
        break;
      case 2:
        if (user.zodiacSign.isEmpty) {
          ref.read(uiHelperProvider).showSnackBar('Lütfen burcunuzu seçiniz.');
          return false;
        }
        break;
      case 3:
        if (user.gender.isEmpty) {
          ref.read(uiHelperProvider).showSnackBar('Lütfen cinsiyetinizi seçiniz.');
          return false;
        }
        break;
      case 4:
        if (user.workState.isEmpty) {
          ref.read(uiHelperProvider).showSnackBar('Lütfen çalışma durumunuzu seçiniz.');
          return false;
        }
        break;
      case 5:
        if (user.relationShipState.isEmpty) {
          ref.read(uiHelperProvider).showSnackBar('Lütfen ilişkilerinizde bir durum seçiniz.');
          return false;
        }
        break;
    }
    return true;
  }

  // Bir sonraki adıma geçer ya da son adımdaysa kullanıcıyı oluşturur.
  Future<bool> nextStep() async {
    if (!isStepValid()) return false;

    if (!state.isLastStep) {
      state = state.copyWith(currentStep: state.currentStep + 1);
      return true;
    }
    await createUser();
    return true;
  }

  // Bir önceki adıma döner.
  bool previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
      return true;
    }
    return false;
  }

  // UserModel'in alanlarını günceller.
  void updateUser({
    String? name,
    DateTime? birthDate,
    String? location,
    String? zodiacSign,
    String? gender,
    String? workState,
    String? relationShipState,
  }) {
    final newUser = state.user.copyWith(
      name: name ?? state.user.name,
      birthDate: birthDate ?? state.user.birthDate,
      location: location ?? state.user.location,
      zodiacSign: zodiacSign ?? state.user.zodiacSign,
      gender: gender ?? state.user.gender,
      workState: workState ?? state.user.workState,
      relationShipState: relationShipState ?? state.user.relationShipState,
    );
    state = state.copyWith(user: newUser);
  }

  // Mock Firebase'e kaydeder, CurrentUser'ı günceller, ana sayfaya yönlendirir.
  Future<void> createUser() async {
    final user = state.user;
    if (kDebugMode) {
      print(
        'user created ${user.name} ${user.birthDate}, ${user.location}, ${user.zodiacSign}, ${user.gender}, ${user.workState}, ${user.relationShipState}',
      );
    }

    await ref.read(userRepositoryProvider).update(user);
    ref.read(currentUserProvider.notifier).updateUser(user);
    await requestNotificationPermission();
    await requestTrackingPermission();
    ref.read(appNavigatorProvider).pushAndRemoveUntil(AppRoutes.home);
  }

  // Kullanım koşulları onay kutusunu değiştirir.
  void toggleChecked(bool value) {
    state = state.copyWith(isChecked: value);
  }

  Future<void> requestTrackingPermission() async {}

  Future<void> requestNotificationPermission() async {}
}
