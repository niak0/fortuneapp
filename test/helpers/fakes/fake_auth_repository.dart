import 'package:fortuneapp/core/data/auth_repository.dart';

// Test'lerde AuthRepository yerine kullanılan in-memory fake.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({bool loggedIn = false}) : _loggedIn = loggedIn;
  bool _loggedIn;
  int signInCallCount = 0;
  int signOutCallCount = 0;

  @override
  bool get isLoggedIn => _loggedIn;

  @override
  Future<bool> signIn({
    String email = 'test@test.com',
    String password = 'test123',
  }) async {
    signInCallCount++;
    _loggedIn = true;
    return true;
  }

  @override
  Future<void> signOut() async {
    signOutCallCount++;
    _loggedIn = false;
  }
}
