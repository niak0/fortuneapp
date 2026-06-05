// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Aktif tema kimliğini tutan ve seçimi kalıcı yazan controller (ViewModel).
///
/// Açılışta varsayılan [MysticThemeId.candlelight] ile başlar, ardından
/// SharedPreferences'tan kayıtlı temayı asenkron hidratlar.

@ProviderFor(AppTheme)
final appThemeProvider = AppThemeProvider._();

/// Aktif tema kimliğini tutan ve seçimi kalıcı yazan controller (ViewModel).
///
/// Açılışta varsayılan [MysticThemeId.candlelight] ile başlar, ardından
/// SharedPreferences'tan kayıtlı temayı asenkron hidratlar.
final class AppThemeProvider
    extends $NotifierProvider<AppTheme, MysticThemeId> {
  /// Aktif tema kimliğini tutan ve seçimi kalıcı yazan controller (ViewModel).
  ///
  /// Açılışta varsayılan [MysticThemeId.candlelight] ile başlar, ardından
  /// SharedPreferences'tan kayıtlı temayı asenkron hidratlar.
  AppThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeHash();

  @$internal
  @override
  AppTheme create() => AppTheme();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MysticThemeId value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MysticThemeId>(value),
    );
  }
}

String _$appThemeHash() => r'34101a0251b77d00a1e734998ca21d398f881ead';

/// Aktif tema kimliğini tutan ve seçimi kalıcı yazan controller (ViewModel).
///
/// Açılışta varsayılan [MysticThemeId.candlelight] ile başlar, ardından
/// SharedPreferences'tan kayıtlı temayı asenkron hidratlar.

abstract class _$AppTheme extends $Notifier<MysticThemeId> {
  MysticThemeId build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MysticThemeId, MysticThemeId>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MysticThemeId, MysticThemeId>,
              MysticThemeId,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Aktif temadan türetilmiş `ThemeData` — `MaterialApp` bunu izler.

@ProviderFor(appThemeData)
final appThemeDataProvider = AppThemeDataProvider._();

/// Aktif temadan türetilmiş `ThemeData` — `MaterialApp` bunu izler.

final class AppThemeDataProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Aktif temadan türetilmiş `ThemeData` — `MaterialApp` bunu izler.
  AppThemeDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeDataHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return appThemeData(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$appThemeDataHash() => r'b40f95bf1485c8dc70c8a8aed36bed7752ce79c1';
