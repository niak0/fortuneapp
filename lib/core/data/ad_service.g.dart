// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adService)
final adServiceProvider = AdServiceProvider._();

final class AdServiceProvider
    extends $FunctionalProvider<AdService, AdService, AdService>
    with $Provider<AdService> {
  AdServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adServiceHash();

  @$internal
  @override
  $ProviderElement<AdService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AdService create(Ref ref) {
    return adService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdService>(value),
    );
  }
}

String _$adServiceHash() => r'0169ed449e13afed8e6f5af0a661dbf6b1f43299';
