import 'package:flutter_test/flutter_test.dart';
import 'package:fortuneapp/core/auth/current_user.dart';
import 'package:fortuneapp/core/data/fortune_repository.dart';
import 'package:fortuneapp/core/data/user_repository.dart';
import 'package:fortuneapp/core/ui/ui_helper.dart';
import 'package:fortuneapp/core/models/user_model.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';
import 'package:fortuneapp/features/fortune_coffee/fortune_coffee_providers.dart';

import '../helpers/fakes/fake_fortune_repository.dart';
import '../helpers/fakes/fake_ui_helper.dart';
import '../helpers/fakes/fake_user_repository.dart';
import '../helpers/provider_container_helper.dart';

UserModel _user({int coin = 5}) => UserModel(
  name: 'Ada',
  birthDate: DateTime(1990, 1, 1),
  location: 'İstanbul',
  zodiacSign: 'capricorn',
  gender: 'woman',
  workState: 'student',
  relationshipState: 'single',
  coin: coin,
);

void main() {
  group('Kahve falı akışı (async pending)', () {
    test('geçerli akışta pending fal oluşturulur ve altın düşer', () async {
      final repo = FakeFortuneRepository();
      final userRepo = FakeUserRepository(initial: _user(coin: 5));
      final container = makeContainer(
        overrides: [
          fortuneRepositoryProvider.overrideWithValue(repo),
          userRepositoryProvider.overrideWithValue(userRepo),
          uiHelperProvider.overrideWithValue(FakeUiHelper()),
        ],
      );
      final user = await container.read(currentUserProvider.future);
      final notifier = container.read(fortuneCoffeeViewModelProvider.notifier);
      notifier.selectFortuneTopic(FortuneTopic.love);

      final ok = await notifier.getFortuneAndSaveFirebase(user!);

      expect(ok, true);
      final call = repo.createCalls.single;
      expect(call.contentType, ContentType.coffee);
      expect(call.fortuneTopic, FortuneTopic.love);
      expect(call.request['topicLabel'], 'Aşk');
      expect(call.request.containsKey('userContext'), true);
      expect(call.request['images'], isEmpty);
      // Altın oluşturma anında düşer (üretim arka planda).
      expect(container.read(currentUserProvider).value?.coin, 4);
    });

    test('yeterli altın yoksa pending fal oluşturulmaz', () async {
      final repo = FakeFortuneRepository();
      final ui = FakeUiHelper();
      final container = makeContainer(
        overrides: [
          fortuneRepositoryProvider.overrideWithValue(repo),
          userRepositoryProvider.overrideWithValue(
            FakeUserRepository(initial: _user(coin: 0)),
          ),
          uiHelperProvider.overrideWithValue(ui),
        ],
      );
      final user = await container.read(currentUserProvider.future);
      final notifier = container.read(fortuneCoffeeViewModelProvider.notifier);
      notifier.selectFortuneTopic(FortuneTopic.general);

      final ok = await notifier.getFortuneAndSaveFirebase(user!);

      expect(ok, false);
      expect(repo.createCalls, isEmpty);
      expect(ui.snackBars, contains('Yeterli altının yok'));
    });

    test('konu seçilmezse fal oluşturulmaz', () async {
      final repo = FakeFortuneRepository();
      final container = makeContainer(
        overrides: [
          fortuneRepositoryProvider.overrideWithValue(repo),
          userRepositoryProvider.overrideWithValue(
            FakeUserRepository(initial: _user(coin: 5)),
          ),
          uiHelperProvider.overrideWithValue(FakeUiHelper()),
        ],
      );
      final user = await container.read(currentUserProvider.future);
      final notifier = container.read(fortuneCoffeeViewModelProvider.notifier);

      final ok = await notifier.getFortuneAndSaveFirebase(user!);

      expect(ok, false);
      expect(repo.createCalls, isEmpty);
      expect(container.read(currentUserProvider).value?.coin, 5);
    });
  });
}
