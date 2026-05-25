import '../../core/models/user_model.dart';

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

  UserSetupState copyWith(
          {int? currentStep, UserModel? user, bool? isChecked}) =>
      UserSetupState(
        currentStep: currentStep ?? this.currentStep,
        user: user ?? this.user,
        isChecked: isChecked ?? this.isChecked,
      );
}
