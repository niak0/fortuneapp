// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gold_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(goldManager)
final goldManagerProvider = GoldManagerProvider._();

final class GoldManagerProvider
    extends $FunctionalProvider<GoldManager, GoldManager, GoldManager>
    with $Provider<GoldManager> {
  GoldManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goldManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goldManagerHash();

  @$internal
  @override
  $ProviderElement<GoldManager> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoldManager create(Ref ref) {
    return goldManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoldManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoldManager>(value),
    );
  }
}

String _$goldManagerHash() => r'6ac103fc4f8a611dfecf4acad1cf1f5a7832d040';
