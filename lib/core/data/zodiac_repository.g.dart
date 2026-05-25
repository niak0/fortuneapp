// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zodiac_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(zodiacRepository)
final zodiacRepositoryProvider = ZodiacRepositoryProvider._();

final class ZodiacRepositoryProvider
    extends
        $FunctionalProvider<
          ZodiacRepository,
          ZodiacRepository,
          ZodiacRepository
        >
    with $Provider<ZodiacRepository> {
  ZodiacRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zodiacRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zodiacRepositoryHash();

  @$internal
  @override
  $ProviderElement<ZodiacRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ZodiacRepository create(Ref ref) {
    return zodiacRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ZodiacRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ZodiacRepository>(value),
    );
  }
}

String _$zodiacRepositoryHash() => r'2bd46f7a1508b78d6f18400569538bec25951166';
