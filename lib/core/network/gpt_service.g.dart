// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gpt_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gptService)
final gptServiceProvider = GptServiceProvider._();

final class GptServiceProvider
    extends $FunctionalProvider<GptService, GptService, GptService>
    with $Provider<GptService> {
  GptServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gptServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gptServiceHash();

  @$internal
  @override
  $ProviderElement<GptService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GptService create(Ref ref) {
    return gptService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GptService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GptService>(value),
    );
  }
}

String _$gptServiceHash() => r'0cd842e8436e99faf40f4fcbc9524918e62c2115';
