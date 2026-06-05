import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/auth/auth_notifier.dart';
import 'package:fortuneapp/core/navigation/app_navigator.dart';
import 'package:fortuneapp/core/theme/mystic_dimens.dart';
import 'package:fortuneapp/core/theme/theme_providers.dart';

import 'settings_providers.dart';

// Uygulama ayarları ekranı.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsViewModelProvider);
    final notifier = ref.read(settingsViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => ref.read(appNavigatorProvider).pop(),
        ),
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ayarlar yüklenemedi: $e')),
        data: (settings) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Altın Kullanırken Sor'),
                      value: settings.askBeforeUsingGold,
                      onChanged: notifier.setAskBeforeUsingGold,
                    ),
                    const Divider(height: 0),
                    SwitchListTile(
                      title: const Text('Bildirimler'),
                      value: settings.notificationsEnabled,
                      onChanged: notifier.setNotificationsEnabled,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const _ThemePicker(),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  title: const Text('Çıkış Yap'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    await ref.read(authProvider.notifier).signOut();
                    // Bootstrap yeni anon login yapar; home'a düş.
                    if (context.mounted) {
                      ref
                          .read(appNavigatorProvider)
                          .pushAndRemoveUntil(AppRoutes.home);
                    }
                  },
                ),
              ),
              TextButton(
                onPressed: () => _showDeleteAccountDialog(context, ref),
                child: Text(
                  'Hesabımı Sil',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Fortune App v1', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  // Hesap silme onay diyaloğu.
  Future<void> _showDeleteAccountDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final errorColor = Theme.of(context).colorScheme.error;
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Hesabı Sil'),
          content: const Text(
            'Hesabınızı silmek istediğinizden emin misiniz? '
            'Bu işlem geri alınamaz.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text('Sil', style: TextStyle(color: errorColor)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await ref.read(authProvider.notifier).signOut();
                if (context.mounted) {
                  ref
                      .read(appNavigatorProvider)
                      .pushAndRemoveUntil(AppRoutes.home);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

// Tema seçici — 4 mistik tema arası anında geçiş (seçim kalıcı yazılır).
class _ThemePicker extends ConsumerWidget {
  const _ThemePicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(appThemeProvider);
    final text = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text('Tema', style: text.titleMedium),
              ],
            ),
            const SizedBox(height: MysticSpace.x4),
            Wrap(
              spacing: MysticSpace.x4,
              runSpacing: MysticSpace.x3,
              children: [
                for (final id in MysticThemeId.values)
                  _ThemeSwatch(
                    id: id,
                    selected: id == current,
                    onTap: () =>
                        ref.read(appThemeProvider.notifier).setTheme(id),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Tek bir temayı temsil eden seçilebilir renk dairesi + adı.
class _ThemeSwatch extends StatelessWidget {
  const _ThemeSwatch({
    required this.id,
    required this.selected,
    required this.onTap,
  });

  final MysticThemeId id;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final palette = id.palette;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Temanın zemin → altın geçişiyle minik önizleme.
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [palette.bgGlow, palette.gold],
              ),
              border: Border.all(
                color: selected ? palette.goldBright : scheme.outlineVariant,
                width: selected ? 2 : 1,
              ),
            ),
            child: selected
                ? Icon(Icons.check, size: 20, color: palette.onAccent)
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            id.label,
            style: text.labelSmall?.copyWith(
              color: selected ? scheme.primary : scheme.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
