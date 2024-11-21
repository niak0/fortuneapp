import 'package:flutter/material.dart';
import '../../core/models/current_user.dart';
import '../../core/models/user_model.dart';
import '../../core/network/mock_service.dart';

class ProfileEditViewModel extends ChangeNotifier {
  final CurrentUser _currentUser;
  late UserModel user;

  ProfileEditViewModel(this._currentUser) {
    user = _currentUser.currentUser!;
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
    user = user.copyWith(
      name: name,
      birthDate: birthDate,
      location: location,
      zodiacSign: zodiacSign,
      gender: gender,
      workState: workState,
      relationShipState: relationShipState,
    );
    notifyListeners();
  }

  Future<void> saveUserChanges() async {
    await MockService.updateUserProfile(user.toJson());
    _currentUser.updateUser(user);
  }
}
