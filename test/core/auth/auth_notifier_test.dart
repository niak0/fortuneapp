import 'package:flutter_test/flutter_test.dart';
import 'package:fortuneapp/core/auth/auth_notifier.dart';
import 'package:fortuneapp/core/auth/auth_user.dart';
import 'package:fortuneapp/core/data/auth_repository.dart';

import '../../helpers/fakes/fake_auth_repository.dart';
import '../../helpers/provider_container_helper.dart';

void main() {
  group('AuthNotifier', () {
    test('signInWithGoogle anon kullanıcıyı upgrade eder', () async {
      final fake = FakeAuthRepository(
        initial: const AuthUser(uid: 'anon-1', isAnonymous: true),
      );
      final container = makeContainer(overrides: [
        authRepositoryProvider.overrideWithValue(fake),
      ]);

      expect(container.read(authProvider)?.isAnonymous, true);

      await container.read(authProvider.notifier).signInWithGoogle();

      expect(container.read(authProvider)?.isAnonymous, false);
      expect(fake.googleCallCount, 1);
    });

    test('signOut state\'i null yapar', () async {
      final fake = FakeAuthRepository(
        initial: const AuthUser(uid: 'u1', isAnonymous: false),
      );
      final container = makeContainer(overrides: [
        authRepositoryProvider.overrideWithValue(fake),
      ]);

      expect(container.read(authProvider), isNotNull);

      await container.read(authProvider.notifier).signOut();

      expect(container.read(authProvider), isNull);
      expect(fake.signOutCallCount, 1);
    });
  });
}
