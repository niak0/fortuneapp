import 'package:fortuneapp/core/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

// Mock authentication state'ini tutan global Notifier.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  bool build() => ref.watch(authRepositoryProvider).isLoggedIn;

  // Mock login işlemi.
  Future<bool> signIn({
    String email = 'test@test.com',
    String password = 'test123',
  }) async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.signIn(email: email, password: password);
    state = repo.isLoggedIn;
    return result;
  }

  // Mock logout işlemi.
  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
    state = repo.isLoggedIn;
  }
}
