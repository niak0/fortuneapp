import 'package:fortuneapp/core/network/mock_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_manager.g.dart';

// Mock authentication state'ini tutan global Notifier.
@Riverpod(keepAlive: true)
class AuthManager extends _$AuthManager {
  @override
  bool build() => MockService.isUserLoggedIn;

  // Mock login işlemi.
  Future<bool> signIn({
    String email = 'test@test.com',
    String password = 'test123',
  }) async {
    final result = await MockService.signIn(email, password);
    state = MockService.isUserLoggedIn;
    return result;
  }

  // Mock logout işlemi.
  Future<void> signOut() async {
    await MockService.signOut();
    state = MockService.isUserLoggedIn;
  }
}
