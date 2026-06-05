import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/settings_repository.dart';
import 'app_theme.dart';
import 'mystic_theme_id.dart';

export 'mystic_theme_id.dart';

part 'theme_providers.g.dart';

/// Aktif tema kimliğini tutan ve seçimi kalıcı yazan controller (ViewModel).
///
/// Açılışta varsayılan [MysticThemeId.candlelight] ile başlar, ardından
/// SharedPreferences'tan kayıtlı temayı asenkron hidratlar.
@Riverpod(keepAlive: true)
class AppTheme extends _$AppTheme {
  // Kullanıcı açıkça tema seçtiyse asenkron hidrat seçimi ezmemeli.
  bool _userChanged = false;

  @override
  MysticThemeId build() {
    _hydrate();
    return MysticThemeId.candlelight;
  }

  // Kalıcı tema kimliğini yükler; kayıt yoksa veya kullanıcı bu sırada seçim
  // yaptıysa varsayılan/seçili değerde kalır.
  Future<void> _hydrate() async {
    final id = await ref.read(settingsRepositoryProvider).getThemeId();
    if (_userChanged) return;
    final resolved = MysticThemeId.fromId(id);
    if (resolved != state) state = resolved;
  }

  /// Temayı değiştirir ve seçimi kalıcı yazar.
  Future<void> setTheme(MysticThemeId id) async {
    _userChanged = true;
    if (id == state) return;
    state = id;
    await ref.read(settingsRepositoryProvider).setThemeId(id.name);
  }
}

/// Aktif temadan türetilmiş `ThemeData` — `MaterialApp` bunu izler.
@Riverpod(keepAlive: true)
ThemeData appThemeData(Ref ref) =>
    MysticTheme.themeFor(ref.watch(appThemeProvider));
