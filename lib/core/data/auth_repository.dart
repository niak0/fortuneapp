import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/auth_user.dart';
import 'firebase_auth_repository.dart';

part 'auth_repository.g.dart';

// Authentication için domain interface'i.
// FirebaseAuthRepository (production) ve MockAuthRepository (test) implementasyonları.
abstract class AuthRepository {
  // Auth state değişimlerini stream olarak yayınlar (sign-in/sign-out/anon).
  Stream<AuthUser?> authStateChanges();

  // Anlık snapshot — splash/bootstrap için.
  AuthUser? get currentUser;

  // Aktif kullanıcı anonim mi?
  bool get isAnonymous;

  // Anonim oturum açar (UID üretir).
  Future<AuthUser?> signInAnonymously();

  // Google ile giriş; anon ise linkWithCredential ile UID korunur.
  Future<AuthUser?> signInWithGoogle();

  // Apple ile giriş; anon ise linkWithCredential ile UID korunur.
  Future<AuthUser?> signInWithApple();

  // Oturumu kapatır (yeni anon login bootstrap tarafından sağlanır).
  Future<void> signOut();
}

// AuthRepository DI provider'ı (production = FirebaseAuthRepository).
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => FirebaseAuthRepository();
