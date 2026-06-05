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
        relationshipState: 'single',
      );
      final container = makeContainer(
        overrides: [
          userRepositoryProvider.overrideWithValue(
            FakeUserRepository(initial: initial),
          ),
        ],
      );

      final user = await container.read(currentUserProvider.future);

      expect(user, isNotNull);
      expect(user!.name, 'Ada');
    });

    test(
      'profil yoksa varsayılan (Misafir) profil otomatik oluşturulur',
      () async {
        final container = makeContainer(
          overrides: [
            userRepositoryProvider.overrideWithValue(FakeUserRepository()),
          ],
        );

        final user = await container.read(currentUserProvider.future);

        expect(user, isNotNull);
        expect(user!.name, 'Misafir');
        expect(user.coin, 3);
      },
    );

    test('incrementGold altını artırır ve Firestore\'a kalıcı yazar', () async {
      final initial = UserModel(
        name: 'Ada',
        birthDate: DateTime(1990, 1, 1),
        location: '',
        zodiacSign: '',
        gender: '',
        workState: '',
        relationshipState: '',
        coin: 5,
      );
      final fake = FakeUserRepository(initial: initial);
      final container = makeContainer(
        overrides: [userRepositoryProvider.overrideWithValue(fake)],
      );
      await container.read(currentUserProvider.future);

      await container
          .read(currentUserProvider.notifier)
          .incrementGold(amount: 3);

      final user = container.read(currentUserProvider).value;
      expect(user?.coin, 8);
      // Bellekte değil Firestore'a da yazıldığını doğrula (gold persistence bug).
      expect(fake.updateCallCount, 1);
    });

    test('update hata verirse altın state geri alınır (rollback)', () async {
      final initial = UserModel(
        name: 'Ada',
        birthDate: DateTime(1990, 1, 1),
        location: '',
        zodiacSign: '',
        gender: '',
        workState: '',
        relationshipState: '',
        coin: 5,
      );
      final container = makeContainer(
        overrides: [
          userRepositoryProvider.overrideWithValue(
            FakeUserRepository(initial: initial, failOnUpdate: true),
          ),
        ],
      );
      await container.read(currentUserProvider.future);

      await container
          .read(currentUserProvider.notifier)
          .incrementGold(amount: 3);

      // Persist başarısız → optimistic değişiklik geri alınır.
      expect(container.read(currentUserProvider).value?.coin, 5);
    });
  });
}
