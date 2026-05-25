import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/mock_service.dart';

part 'auth_repository.g.dart';

// Authentication veri katmanı — testte override edilebilir.
abstract class AuthRepository {
  bool get isLoggedIn;
  Future<bool> signIn({String email, String password});
  Future<void> signOut();
}

// MockService üzerinden çalışan AuthRepository implementasyonu.
class MockAuthRepository implements AuthRepository {
  @override
  bool get isLoggedIn => MockService.isUserLoggedIn;

  @override
  Future<bool> signIn({
    String email = 'test@test.com',
    String password = 'test123',
  }) =>
      MockService.signIn(email, password);

  @override
  Future<void> signOut() => MockService.signOut();
}

// AuthRepository DI provider'ı.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => MockAuthRepository();
