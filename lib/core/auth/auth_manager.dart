import 'package:flutter/foundation.dart';
import '../network/mock_service.dart';

class AuthManager extends ChangeNotifier {
  bool get isLoggedIn => MockService.isUserLoggedIn;

  Future<bool> signIn({String email = "test@test.com", String password = "test123"}) async {
    final result = await MockService.signIn(email, password);
    notifyListeners();
    return result;
  }

  Future<void> signOut() async {
    await MockService.signOut();
    notifyListeners();
  }
}
