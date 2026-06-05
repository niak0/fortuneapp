// Ayarlar ekranının kalıcı (persisted) state'ini tutan değiştirilemez model.
class SettingsState {
  const SettingsState({
    required this.notificationsEnabled,
    required this.askBeforeUsingGold,
  });

  final bool notificationsEnabled;
  final bool askBeforeUsingGold;

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? askBeforeUsingGold,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      askBeforeUsingGold: askBeforeUsingGold ?? this.askBeforeUsingGold,
    );
  }
}
