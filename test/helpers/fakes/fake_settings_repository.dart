import 'package:fortuneapp/core/data/settings_repository.dart';

// Test'lerde SettingsRepository yerine kullanılan in-memory fake.
class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository({
    bool notificationsEnabled = true,
    bool askBeforeUsingGold = true,
    String? themeId,
  }) : _notificationsEnabled = notificationsEnabled,
       _askBeforeUsingGold = askBeforeUsingGold,
       _themeId = themeId;

  bool _notificationsEnabled;
  bool _askBeforeUsingGold;
  String? _themeId;

  @override
  Future<bool> getNotificationsEnabled() async => _notificationsEnabled;

  @override
  Future<void> setNotificationsEnabled(bool value) async =>
      _notificationsEnabled = value;

  @override
  Future<bool> getAskBeforeUsingGold() async => _askBeforeUsingGold;

  @override
  Future<void> setAskBeforeUsingGold(bool value) async =>
      _askBeforeUsingGold = value;

  @override
  Future<String?> getThemeId() async => _themeId;

  @override
  Future<void> setThemeId(String value) async => _themeId = value;
}
