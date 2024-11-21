import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fortuneapp/core/navigation/app_navigator.dart';
import 'package:fortuneapp/core/navigation/app_navigator_manager.dart';
import 'package:fortuneapp/core/network/mock_firebase_service.dart';
import 'package:fortuneapp/features/user_setup/step_widgets/birth_step.dart';
import 'package:fortuneapp/features/user_setup/step_widgets/gender_step.dart';
import 'package:fortuneapp/features/user_setup/step_widgets/name_step.dart';
import 'package:fortuneapp/features/user_setup/step_widgets/relationship_step.dart';
import 'package:fortuneapp/features/user_setup/step_widgets/work_status_step.dart';
import 'package:fortuneapp/features/user_setup/step_widgets/zodiac_step.dart';
import '../../core/widgets/snackbar.dart';
import '../../core/models/current_user.dart';
import '../../core/models/user_model.dart';

class UserSetupViewModel extends ChangeNotifier {
  int _currentStep = 0;
  bool _isChecked = false;

  UserModel get user => _user;
  bool get isChecked => _isChecked;
  int get currentStep => _currentStep;
  int get totalSteps => steps.length;
  bool get isLastStep => _currentStep == totalSteps - 1;

  late UserModel _user;
  late CurrentUser _currentUser;
  late PageController _pageController;

  final List<Widget> steps = [
    NameStep(),
    BirthStep(),
    ZodiacStep(),
    GenderStep(),
    WorkStatusStep(),
    RelationshipStep(),
  ];

  UserSetupViewModel(CurrentUser currentUser) {
    _currentUser = currentUser;
    _user = UserModel(name: "", birthDate: DateTime.now(), location: "", zodiacSign: "", gender: "", workState: "", relationShipState: "");
    _pageController = PageController();
  }

  PageController get pageController => _pageController;
  void updateCurrentStep(int index) {
    _currentStep = index;
    notifyListeners();
  }

  // Her adım için geçerlilik kontrolü
  bool isStepValid() {
    switch (_currentStep) {
      case 0:
        if (_user.name.length < 3) {
          CustomSnackBar.show("Lütfen adınızı giriniz.");
          return false;
        }
        break;
      case 1:
        if (_user.birthDate.isAtSameMomentAs(DateTime.now())) {
          CustomSnackBar.show("Lütfen doğru bir tarih giriniz.");
          return false;
        }
        break;
      case 2:
        if (_user.zodiacSign.isEmpty) {
          CustomSnackBar.show("Lütfen burcunuzu seçiniz.");
          return false;
        }
        break;
      case 3:
        if (_user.gender.isEmpty) {
          CustomSnackBar.show("Lütfen cinsiyetinizi seçiniz.");
          return false;
        }
        break;
      case 4:
        if (_user.workState.isEmpty) {
          CustomSnackBar.show("Lütfen çalışma durumunuzu seçiniz.");
          return false;
        }
        break;
      case 5:
        if (_user.relationShipState.isEmpty) {
          CustomSnackBar.show("Lütfen ilişkilerinizde bir durum seçiniz.");
          return false;
        }
        break;
    }
    return true;
  }

  void nextStep() {
    // Adım doğrulama
    if (!isStepValid()) return;

    if (!isLastStep) {
      _currentStep++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
      notifyListeners();
    } else {
      createUser();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      _pageController.previousPage(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
      notifyListeners();
    }
  }

  void updateUser({
    String? name,
    DateTime? birthDate,
    String? location,
    String? zodiacSign,
    String? gender,
    String? workState,
    String? relationShipState,
  }) {
    _user = _user.copyWith(
      name: name ?? _user.name,
      birthDate: birthDate ?? _user.birthDate,
      location: location ?? _user.location,
      zodiacSign: zodiacSign ?? _user.zodiacSign,
      gender: gender ?? _user.gender,
      workState: workState ?? _user.workState,
      relationShipState: relationShipState ?? _user.relationShipState,
    );
    notifyListeners();
  }

  Future<void> createUser() async {
    if (kDebugMode) {
      print(
          "user created ${_user.name} ${_user.birthDate}, ${_user.location}, ${_user.zodiacSign}, ${_user.gender}, ${_user.workState}, ${_user.relationShipState}");
    }

    await MockFirebaseService().saveUserToFireStore(_user);
    _currentUser.updateUser(_user);
    await requestNotificationPermission();
    await requestTrackingPermission();
    AppNavigatorManager.instance.pushAndRemoveUntil(AppRoutes.home);
  }

  void toggleChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }

  Future<void> requestTrackingPermission() async {
    // Uygulama başlatıldığında izin isteği gönder

    // if (status == TrackingStatus.authorized) {
    //   print("Tracking izni verildi.");
    //   // Kişiselleştirilmiş reklamlar gösterilebilir.
    // } else {
    //   print("Tracking izni verilmedi.");
    //   // Kişiselleştirilmemiş reklam gösterilebilir.
    // }
  }

  Future<void> requestNotificationPermission() async {}
}
