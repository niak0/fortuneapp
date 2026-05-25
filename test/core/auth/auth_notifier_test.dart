import 'package:flutter_test/flutter_test.dart';
import 'package:fortuneapp/core/auth/auth_notifier.dart';
import 'package:fortuneapp/core/data/auth_repository.dart';

import '../../helpers/fakes/fake_auth_repository.dart';
import '../../helpers/provider_container_helper.dart';

void main() {
  group('AuthNotifier', () {
    test('signIn loggedIn state\'ini true yapar', () async {
      final fake = FakeAuthRepository(loggedIn: false);
      final container = makeContainer(overrides: [
        authRepositoryProvider.overrideWithValue(fake),
      ]);

      expect(container.read(authProvider), false);

      await container.read(authProvider.notifier).signIn();

      expect(container.read(authProvider), true);
      expect(fake.signInCallCount, 1);
    });

    test('signOut state\'i false yapar', () async {
      final fake = FakeAuthRepository(loggedIn: true);
      final container = makeContainer(overrides: [
        authRepositoryProvider.overrideWithValue(fake),
      ]);

      expect(container.read(authProvider), true);

      await container.read(authProvider.notifier).signOut();

      expect(container.read(authProvider), false);
      expect(fake.signOutCallCount, 1);
    });
  });
}
