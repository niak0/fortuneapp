import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../auth/auth_user.dart';
import 'auth_repository.dart';

const _logName = 'auth';

void _log(String message) => developer.log(message, name: _logName);

void _logErr(String message, Object error, [StackTrace? stack]) =>
    developer.log(message, name: _logName, error: error, stackTrace: stack);

// Firebase Auth + Google + Apple üzerinden gerçek auth işlemleri.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({fb.FirebaseAuth? auth, GoogleSignIn? googleSignIn})
    : _auth = auth ?? fb.FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final fb.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  bool _googleInitialized = false;

  // Firebase User'ı domain modeline çevirir.
  AuthUser? _map(fb.User? user) {
    if (user == null) return null;
    return AuthUser(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      isAnonymous: user.isAnonymous,
      providerIds: user.providerData.map((p) => p.providerId).toList(),
    );
  }

  @override
  Stream<AuthUser?> authStateChanges() => _auth.authStateChanges().map((u) {
    final mapped = _map(u);
    if (mapped == null) {
      _log('authStateChanges → signed-out');
    } else {
      _log(
        'authStateChanges → uid=${mapped.uid} '
        'anon=${mapped.isAnonymous} '
        'providers=${mapped.providerIds} '
        'email=${mapped.email}',
      );
    }
    return mapped;
  });

  @override
  AuthUser? get currentUser => _map(_auth.currentUser);

  @override
  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? false;

  @override
  Future<AuthUser?> signInAnonymously() async {
    _log('signInAnonymously() başlatılıyor...');
    try {
      final cred = await _auth.signInAnonymously();
      _log('signInAnonymously() OK → uid=${cred.user?.uid}');
      return _map(cred.user);
    } catch (e, s) {
      _logErr('signInAnonymously() FAILED', e, s);
      rethrow;
    }
  }

  // Anon ise upgrade (linkWithCredential), değilse signInWithCredential.
  Future<AuthUser?> _signInOrLink(fb.AuthCredential credential) async {
    final current = _auth.currentUser;
    if (current != null && current.isAnonymous) {
      _log('Anon kullanıcı (uid=${current.uid}) → linkWithCredential');
      try {
        final cred = await current.linkWithCredential(credential);
        _log(
          'linkWithCredential OK → uid=${cred.user?.uid} '
          'providers=${cred.user?.providerData.map((p) => p.providerId).toList()}',
        );
        return _map(cred.user);
      } on fb.FirebaseAuthException catch (e, s) {
        _logErr('linkWithCredential FAILED (code=${e.code})', e, s);
        // Credential başka bir hesaba bağlıysa o hesapla normal giriş yap.
        if (e.code == 'credential-already-in-use' ||
            e.code == 'email-already-in-use') {
          _log('Credential başka hesapta — signInWithCredential ile geç');
          final cred = await _auth.signInWithCredential(credential);
          _log('signInWithCredential OK → uid=${cred.user?.uid}');
          return _map(cred.user);
        }
        rethrow;
      }
    }
    _log('Anon değil → signInWithCredential');
    final cred = await _auth.signInWithCredential(credential);
    _log('signInWithCredential OK → uid=${cred.user?.uid}');
    return _map(cred.user);
  }

  @override
  Future<AuthUser?> signInWithGoogle() async {
    _log('signInWithGoogle() başlatılıyor...');
    try {
      if (!_googleInitialized) {
        await _googleSignIn.initialize();
        _googleInitialized = true;
        _log('GoogleSignIn initialize OK');
      }
      final account = await _googleSignIn.authenticate();
      _log('Google authenticate OK → email=${account.email}');
      final auth = account.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );
      return _signInOrLink(credential);
    } catch (e, s) {
      _logErr('signInWithGoogle() FAILED', e, s);
      rethrow;
    }
  }

  @override
  Future<AuthUser?> signInWithApple() async {
    _log('signInWithApple() başlatılıyor...');
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      _log('Apple credential alındı → email=${appleCredential.email}');
      final credential = fb.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      return _signInOrLink(credential);
    } catch (e, s) {
      _logErr('signInWithApple() FAILED', e, s);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    _log('signOut() — önceki uid=${_auth.currentUser?.uid}');
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
    _log('signOut() OK');
  }
}
