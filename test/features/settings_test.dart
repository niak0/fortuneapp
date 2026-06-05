import 'package:flutter_test/flutter_test.dart';
import 'package:fortuneapp/core/data/settings_repository.dart';
import 'package:fortuneapp/features/settings/settings_providers.dart';

import '../helpers/fakes/fake_settings_repository.dart';
import '../helpers/provider_container_helper.dart';

void main() {
  group('SettingsViewModel', () {
    test('build() ayarları repository\'den yükler', () async {
      final container = makeContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            FakeSettingsRepository(
              notificationsEnabled: false,
              askBeforeUsingGold: true,
            ),
          ),
        ],
      );

      final state = await container.read(settingsViewModelProvider.future);

      expect(state.notificationsEnabled, isFalse);
      expect(state.askBeforeUsingGold, isTrue);
    });

    test(
      'setNotificationsEnabled state\'i ve repository\'yi günceller',
      () async {
        final repo = FakeSettingsRepository();
        final container = makeContainer(
          overrides: [settingsRepositoryProvider.overrideWithValue(repo)],
        );
        await container.read(settingsViewModelProvider.future);

        await container
            .read(settingsViewModelProvider.notifier)
            .setNotificationsEnabled(false);

        expect(
          container.read(settingsViewModelProvider).value?.notificationsEnabled,
          isFalse,
        );
        expect(await repo.getNotificationsEnabled(), isFalse);
      },
    );

    test('setAskBeforeUsingGold tercihi kalıcı yazar', () async {
      final repo = FakeSettingsRepository(askBeforeUsingGold: true);
      final container = makeContainer(
        overrides: [settingsRepositoryProvider.overrideWithValue(repo)],
      );
      await container.read(settingsViewModelProvider.future);

      await container
          .read(settingsViewModelProvider.notifier)
          .setAskBeforeUsingGold(false);

      expect(await repo.getAskBeforeUsingGold(), isFalse);
    });
  });
}
