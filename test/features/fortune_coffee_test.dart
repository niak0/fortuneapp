import 'package:flutter_test/flutter_test.dart';
import 'package:fortuneapp/core/auth/current_user.dart';
import 'package:fortuneapp/core/data/fortune_repository.dart';
import 'package:fortuneapp/core/data/user_repository.dart';
import 'package:fortuneapp/core/network/gpt_service.dart';
import 'package:fortuneapp/core/ui/ui_helper.dart';
import 'package:fortuneapp/core/models/user_model.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';
import 'package:fortuneapp/features/fortune_coffee/fortune_coffee_providers.dart';

import '../helpers/fakes/fake_fortune_repository.dart';
import '../helpers/fakes/fake_gpt_service.dart';
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
  group('Kahve falı akışı', () {
    test('geçerli akışta GPT çağrılır, fal kaydedilir, altın düşer', () async {
      final repo = FakeFortuneRepository();
      final gpt = FakeGptService(reply: 'kahve falın hazır');
      final userRepo = FakeUserRepository(initial: _user(coin: 5));
      final container = makeContainer(
        overrides: [
          fortuneRepositoryProvider.overrideWithValue(repo),
          gptServiceProvider.overrideWithValue(gpt),
          userRepositoryProvider.overrideWithValue(userRepo),
          uiHelperProvider.overrideWithValue(FakeUiHelper()),
        ],
      );
      final user = await container.read(currentUserProvider.future);
      final notifier = container.read(fortuneCoffeeViewModelProvider.notifier);
      notifier.selectFortuneTopic(FortuneTopic.love);

      final ok = await notifier.getFortuneAndSaveFirebase(user!);

      expect(ok, true);
      expect(gpt.callCount, 1);
      expect(gpt.lastContentType, ContentType.coffee);
      expect(repo.addCalls.single.contentType, ContentType.coffee);
      expect(repo.addCalls.single.fortuneTopic, FortuneTopic.love);
      expect(container.read(currentUserProvider).value?.coin, 4);
    });

    test('yeterli altın yoksa GPT çağrılmaz ve fal eklenmez', () async {
      final repo = FakeFortuneRepository();
      final gpt = FakeGptService(reply: 'olmamalı');
      final ui = FakeUiHelper();
      final container = makeContainer(
        overrides: [
          fortuneRepositoryProvider.overrideWithValue(repo),
          gptServiceProvider.overrideWithValue(gpt),
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
      expect(gpt.callCount, 0);
      expect(repo.addCalls, isEmpty);
      expect(ui.snackBars, contains('Yeterli altının yok'));
    });

    test('GPT null dönerse fal eklenmez ve altın düşmez', () async {
      final repo = FakeFortuneRepository();
      final gpt = FakeGptService(reply: null);
      final userRepo = FakeUserRepository(initial: _user(coin: 5));
      final container = makeContainer(
        overrides: [
          fortuneRepositoryProvider.overrideWithValue(repo),
          gptServiceProvider.overrideWithValue(gpt),
          userRepositoryProvider.overrideWithValue(userRepo),
          uiHelperProvider.overrideWithValue(FakeUiHelper()),
        ],
      );
      final user = await container.read(currentUserProvider.future);
      final notifier = container.read(fortuneCoffeeViewModelProvider.notifier);
      notifier.selectFortuneTopic(FortuneTopic.health);

      final ok = await notifier.getFortuneAndSaveFirebase(user!);

      expect(ok, false);
      expect(repo.addCalls, isEmpty);
      expect(container.read(currentUserProvider).value?.coin, 5);
    });
  });
}
