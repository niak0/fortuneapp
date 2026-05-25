// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_helper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(uiHelper)
final uiHelperProvider = UiHelperProvider._();

final class UiHelperProvider
    extends $FunctionalProvider<UiHelper, UiHelper, UiHelper>
    with $Provider<UiHelper> {
  UiHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uiHelperProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uiHelperHash();

  @$internal
  @override
  $ProviderElement<UiHelper> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UiHelper create(Ref ref) {
    return uiHelper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UiHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UiHelper>(value),
    );
  }
}

String _$uiHelperHash() => r'4422acf6e3e671a4ab019882473d4c1ae3af0d35';
