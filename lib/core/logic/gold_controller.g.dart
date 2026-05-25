// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gold_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(goldController)
final goldControllerProvider = GoldControllerProvider._();

final class GoldControllerProvider
    extends $FunctionalProvider<GoldController, GoldController, GoldController>
    with $Provider<GoldController> {
  GoldControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goldControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goldControllerHash();

  @$internal
  @override
  $ProviderElement<GoldController> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoldController create(Ref ref) {
    return goldController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoldController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoldController>(value),
    );
  }
}

String _$goldControllerHash() => r'959c3952f9feb281e586390e3ac92052608044bb';
