// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fortune_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fortuneRepository)
final fortuneRepositoryProvider = FortuneRepositoryProvider._();

final class FortuneRepositoryProvider
    extends
        $FunctionalProvider<
          FortuneRepository,
          FortuneRepository,
          FortuneRepository
        >
    with $Provider<FortuneRepository> {
  FortuneRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fortuneRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fortuneRepositoryHash();

  @$internal
  @override
  $ProviderElement<FortuneRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FortuneRepository create(Ref ref) {
    return fortuneRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FortuneRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FortuneRepository>(value),
    );
  }
}

String _$fortuneRepositoryHash() => r'599e28893366ce0bcbb4b4190a6d391328169bef';
