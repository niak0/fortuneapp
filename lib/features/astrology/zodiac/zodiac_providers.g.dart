// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zodiac_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ZodiacViewModel)
final zodiacViewModelProvider = ZodiacViewModelProvider._();

final class ZodiacViewModelProvider
    extends $AsyncNotifierProvider<ZodiacViewModel, ZodiacState> {
  ZodiacViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zodiacViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zodiacViewModelHash();

  @$internal
  @override
  ZodiacViewModel create() => ZodiacViewModel();
}

String _$zodiacViewModelHash() => r'7a3dbc4298b4bff9435a487332887f2c28637716';

abstract class _$ZodiacViewModel extends $AsyncNotifier<ZodiacState> {
  FutureOr<ZodiacState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ZodiacState>, ZodiacState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ZodiacState>, ZodiacState>,
              AsyncValue<ZodiacState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
