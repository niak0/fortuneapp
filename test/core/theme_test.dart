import 'package:flutter_test/flutter_test.dart';
import 'package:fortuneapp/core/data/settings_repository.dart';
import 'package:fortuneapp/core/theme/theme_providers.dart';

import '../helpers/fakes/fake_settings_repository.dart';
import '../helpers/provider_container_helper.dart';

void main() {
  group('AppTheme', () {
    test('kayıt yoksa varsayılan Mum Işığı temasıyla başlar', () {
      final container = makeContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            FakeSettingsRepository(),
          ),
        ],
      );

      expect(container.read(appThemeProvider), MysticThemeId.candlelight);
    });

    test('kalıcı tema kimliğini hidratlar', () async {
      final container = makeContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            FakeSettingsRepository(themeId: 'midnight'),
          ),
        ],
      );

      // build() önce varsayılan döner, ardından async hidrat çalışır.
      container.read(appThemeProvider);
      await Future<void>.delayed(Duration.zero);

      expect(container.read(appThemeProvider), MysticThemeId.midnight);
    });

    test('setTheme state\'i ve repository\'yi günceller', () async {
      final repo = FakeSettingsRepository();
      final container = makeContainer(
        overrides: [settingsRepositoryProvider.overrideWithValue(repo)],
      );

      await container
          .read(appThemeProvider.notifier)
          .setTheme(MysticThemeId.obsidian);

      expect(container.read(appThemeProvider), MysticThemeId.obsidian);
      expect(await repo.getThemeId(), 'obsidian');
    });
  });
}
