import 'package:fortuneapp/core/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_bootstrap.dart';
import 'auth_user.dart';

part 'auth_notifier.g.dart';

// Auth state'ini Firebase auth stream'inden besleyen global Notifier.
// Stream her emit'ettiğinde rebuild olur — UI otomatik senkronize.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthUser? build() {
    final async = ref.watch(authStateChangesProvider);
    return async.value ?? ref.read(authRepositoryProvider).currentUser;
  }

  // Google ile devam et — anon ise upgrade, değilse normal sign-in.
  Future<AuthUser?> signInWithGoogle() async {
    final user = await ref.read(authRepositoryProvider).signInWithGoogle();
    if (user != null) state = user; // stream'i beklemeden anında reflect et
    return user;
  }

  // Apple ile devam et — anon ise upgrade, değilse normal sign-in.
  Future<AuthUser?> signInWithApple() async {
    final user = await ref.read(authRepositoryProvider).signInWithApple();
    if (user != null) state = user;
    return user;
  }

  // Oturumu kapatır; bootstrap yeni anon login üretir.
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = null;
    ref.invalidate(authBootstrapProvider);
  }
}
