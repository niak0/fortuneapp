import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/data/settings_repository.dart';
import 'settings_state.dart';

export 'settings_state.dart';

part 'settings_providers.g.dart';

// Ayarları repository'den yükleyen ve değişiklikleri kalıcı yazan ViewModel.
@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  @override
  Future<SettingsState> build() async {
    final repo = ref.read(settingsRepositoryProvider);
    final notifications = await repo.getNotificationsEnabled();
    final askGold = await repo.getAskBeforeUsingGold();
    return SettingsState(
      notificationsEnabled: notifications,
      askBeforeUsingGold: askGold,
    );
  }

  // Bildirim tercihini günceller ve kalıcı yazar.
  Future<void> setNotificationsEnabled(bool value) async {
    final current = state.value;
    if (current == null) return;
    await ref.read(settingsRepositoryProvider).setNotificationsEnabled(value);
    state = AsyncData(current.copyWith(notificationsEnabled: value));
  }

  // Altın kullanım onayı tercihini günceller ve kalıcı yazar.
  Future<void> setAskBeforeUsingGold(bool value) async {
    final current = state.value;
    if (current == null) return;
    await ref.read(settingsRepositoryProvider).setAskBeforeUsingGold(value);
    state = AsyncData(current.copyWith(askBeforeUsingGold: value));
  }
}
