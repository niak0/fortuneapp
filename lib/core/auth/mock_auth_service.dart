import 'package:fortuneapp/core/models/user_model.dart';

import 'auth_service.dart';
import '../network/mock_service.dart';

class MockAuthService implements IAuthService {
  @override
  Future<UserModel?> login() async {
    await MockService.signIn("test@test.com", "test123");

    return MockService.mockUser;
  }

  @override
  Future<void> logout() async {
    await MockService.signOut();
  }
}
