import 'package:flutter/foundation.dart';
import 'package:fortuneapp/core/models/current_user.dart';
import 'package:fortuneapp/core/navigation/app_navigator.dart';
import 'package:fortuneapp/core/navigation/app_navigator_manager.dart';
import 'package:fortuneapp/core/network/mock_firebase_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/user_model.dart';
import '../../core/widgets/snackbar.dart';

part 'user_setup_view_model.g.dart';

const int userSetupTotalSteps = 6;

// Kullanıcı kurulum akışının (form) state'i.
class UserSetupState {
  final int currentStep;
  final UserModel user;
  final bool isChecked;

  const UserSetupState({
    required this.currentStep,
    required this.user,
    required this.isChecked,
  });

  factory UserSetupState.initial() => UserSetupState(
        currentStep: 0,
        isChecked: false,
        user: UserModel(
          name: '',
          birthDate: DateTime.now(),
          location: '',
          zodiacSign: '',
          gender: '',
          workState: '',
          relationShipState: '',
        ),
      );

  bool get isLastStep => currentStep == userSetupTotalSteps - 1;

  UserSetupState copyWith({int? currentStep, UserModel? user, bool? isChecked}) =>
      UserSetupState(
        currentStep: currentStep ?? this.currentStep,
        user: user ?? this.user,
        isChecked: isChecked ?? this.isChecked,
      );
}

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
          CustomSnackBar.show('Lütfen adınızı giriniz.');
          return false;
        }
        break;
      case 1:
        if (user.birthDate.isAtSameMomentAs(DateTime.now())) {
          CustomSnackBar.show('Lütfen doğru bir tarih giriniz.');
          return false;
        }
        break;
      case 2:
        if (user.zodiacSign.isEmpty) {
          CustomSnackBar.show('Lütfen burcunuzu seçiniz.');
          return false;
        }
        break;
      case 3:
        if (user.gender.isEmpty) {
          CustomSnackBar.show('Lütfen cinsiyetinizi seçiniz.');
          return false;
        }
        break;
      case 4:
        if (user.workState.isEmpty) {
          CustomSnackBar.show('Lütfen çalışma durumunuzu seçiniz.');
          return false;
        }
        break;
      case 5:
        if (user.relationShipState.isEmpty) {
          CustomSnackBar.show('Lütfen ilişkilerinizde bir durum seçiniz.');
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

    await ref.read(mockFirebaseServiceProvider).saveUserToFireStore(user);
    ref.read(currentUserProvider.notifier).updateUser(user);
    await requestNotificationPermission();
    await requestTrackingPermission();
    AppNavigatorManager.instance.pushAndRemoveUntil(AppRoutes.home);
  }

  // Kullanım koşulları onay kutusunu değiştirir.
  void toggleChecked(bool value) {
    state = state.copyWith(isChecked: value);
  }

  Future<void> requestTrackingPermission() async {}

  Future<void> requestNotificationPermission() async {}
}
