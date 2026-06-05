import 'dart:async';

import 'package:fortuneapp/core/auth/auth_user.dart';
import 'package:fortuneapp/core/data/auth_repository.dart';

// Test'lerde AuthRepository yerine kullanılan in-memory fake.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AuthUser? initial}) : _user = initial;

  AuthUser? _user;
  final _controller = StreamController<AuthUser?>.broadcast();
  int anonCallCount = 0;
  int googleCallCount = 0;
  int appleCallCount = 0;
  int signOutCallCount = 0;

  void _emit(AuthUser? user) {
    _user = user;
    _controller.add(user);
  }

  @override
  Stream<AuthUser?> authStateChanges() => _controller.stream;

  @override
  AuthUser? get currentUser => _user;

  @override
  bool get isAnonymous => _user?.isAnonymous ?? false;

  @override
  Future<AuthUser?> signInAnonymously() async {
    anonCallCount++;
    _emit(const AuthUser(uid: 'anon-fake', isAnonymous: true));
    return _user;
  }

  @override
  Future<AuthUser?> signInWithGoogle() async {
    googleCallCount++;
    _emit(
      AuthUser(
        uid: _user?.uid ?? 'google-fake',
        isAnonymous: false,
        email: 'test@example.com',
        providerIds: const ['google.com'],
      ),
    );
    return _user;
  }

  @override
  Future<AuthUser?> signInWithApple() async {
    appleCallCount++;
    _emit(
      AuthUser(
        uid: _user?.uid ?? 'apple-fake',
        isAnonymous: false,
        email: 'test@privaterelay.appleid.com',
        providerIds: const ['apple.com'],
      ),
    );
    return _user;
  }

  @override
  Future<void> signOut() async {
    signOutCallCount++;
    _emit(null);
  }
}
