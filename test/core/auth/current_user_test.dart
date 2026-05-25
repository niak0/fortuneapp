import 'package:flutter_test/flutter_test.dart';
import 'package:fortuneapp/core/auth/current_user.dart';
import 'package:fortuneapp/core/data/user_repository.dart';
import 'package:fortuneapp/core/models/user_model.dart';

import '../../helpers/fakes/fake_user_repository.dart';
import '../../helpers/provider_container_helper.dart';

void main() {
  group('CurrentUser', () {
    test('build() repository.fetchCurrent() ile başlatılır', () async {
      final initial = UserModel(
        name: 'Ada',
        birthDate: DateTime(1990, 1, 1),
        location: 'İstanbul',
        zodiacSign: 'capricorn',
        gender: 'female',
        workState: 'student',
        relationShipState: 'single',
      );
      final container = makeContainer(overrides: [
        userRepositoryProvider
            .overrideWithValue(FakeUserRepository(initial: initial)),
      ]);

      final user = await container.read(currentUserProvider.future);

      expect(user, isNotNull);
      expect(user!.name, 'Ada');
    });

    test('incrementGold mevcut altını artırır', () async {
      final initial = UserModel(
        name: 'Ada',
        birthDate: DateTime(1990, 1, 1),
        location: '',
        zodiacSign: '',
        gender: '',
        workState: '',
        relationShipState: '',
        coin: 5,
      );
      final container = makeContainer(overrides: [
        userRepositoryProvider
            .overrideWithValue(FakeUserRepository(initial: initial)),
      ]);
      await container.read(currentUserProvider.future);

      container.read(currentUserProvider.notifier).incrementGold(amount: 3);

      final user = container.read(currentUserProvider).value;
      expect(user?.coin, 8);
    });
  });
}
