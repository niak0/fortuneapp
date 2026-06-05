import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';
import 'auth_user.dart';

part 'auth_bootstrap.g.dart';

// Firebase auth state stream'i — UI ve router bunu dinler.
@Riverpod(keepAlive: true)
Stream<AuthUser?> authStateChanges(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges();

// App açılışında anonim oturumu garanti eder.
// Mevcut oturum varsa onu döner, yoksa anonim olarak signIn yapar.
@Riverpod(keepAlive: true)
Future<AuthUser?> authBootstrap(Ref ref) async {
  final repo = ref.watch(authRepositoryProvider);
  if (repo.currentUser != null) return repo.currentUser;
  return repo.signInAnonymously();
}
