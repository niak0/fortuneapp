// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fortune_tarot_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FortuneTarotViewModel)
final fortuneTarotViewModelProvider = FortuneTarotViewModelProvider._();

final class FortuneTarotViewModelProvider
    extends $AsyncNotifierProvider<FortuneTarotViewModel, FortuneTarotState> {
  FortuneTarotViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fortuneTarotViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fortuneTarotViewModelHash();

  @$internal
  @override
  FortuneTarotViewModel create() => FortuneTarotViewModel();
}

String _$fortuneTarotViewModelHash() =>
    r'393e0376c2f4176aec26b03f802966c083cbbf7d';

abstract class _$FortuneTarotViewModel
    extends $AsyncNotifier<FortuneTarotState> {
  FutureOr<FortuneTarotState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<FortuneTarotState>, FortuneTarotState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FortuneTarotState>, FortuneTarotState>,
              AsyncValue<FortuneTarotState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
