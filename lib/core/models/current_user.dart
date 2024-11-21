import 'package:flutter/material.dart';
import 'package:fortuneapp/core/models/user_model.dart';
import 'package:fortuneapp/core/network/mock_service.dart';

class CurrentUser extends ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // Mock data ile başlatma
  Future<void> initializeMockUser() async {
    _currentUser = MockService.mockUser;
    notifyListeners();
  }

  // Kullanıcı güncelleme
  void updateUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  // Altın artırma
  void incrementGold({required int amount}) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        coin: _currentUser!.coin + amount,
      );
      notifyListeners();
    }
  }

  // Altın azaltma
  void decrementGold(int amount) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        coin: _currentUser!.coin - amount,
      );
      notifyListeners();
    }
  }

  // Oturumu kapat
  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
