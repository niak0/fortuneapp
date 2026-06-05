import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_repository.g.dart';

// Kullanıcı ayarlarının kalıcı erişimi için abstract interface (testte fake'lenir).
abstract class SettingsRepository {
  Future<bool> getNotificationsEnabled();
  Future<void> setNotificationsEnabled(bool value);
  Future<bool> getAskBeforeUsingGold();
  Future<void> setAskBeforeUsingGold(bool value);
  Future<String?> getThemeId();
  Future<void> setThemeId(String value);
}

// Ayarları SharedPreferences üzerinde saklayan production implementasyonu.
class SharedPreferencesSettingsRepository implements SettingsRepository {
  static const _kNotifications = 'settings_notifications_enabled';
  static const _kAskGold = 'settings_ask_before_gold';
  static const _kThemeId = 'settings_theme_id';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<bool> getNotificationsEnabled() async =>
      (await _prefs).getBool(_kNotifications) ?? true;

  @override
  Future<void> setNotificationsEnabled(bool value) async =>
      (await _prefs).setBool(_kNotifications, value);

  @override
  Future<bool> getAskBeforeUsingGold() async =>
      (await _prefs).getBool(_kAskGold) ?? true;

  @override
  Future<void> setAskBeforeUsingGold(bool value) async =>
      (await _prefs).setBool(_kAskGold, value);

  @override
  Future<String?> getThemeId() async => (await _prefs).getString(_kThemeId);

  @override
  Future<void> setThemeId(String value) async =>
      (await _prefs).setString(_kThemeId, value);
}

// SettingsRepository DI provider'ı (production = SharedPreferences).
@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) =>
    SharedPreferencesSettingsRepository();
