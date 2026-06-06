// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fortune_dream_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FortuneDreamViewModel)
final fortuneDreamViewModelProvider = FortuneDreamViewModelProvider._();

final class FortuneDreamViewModelProvider
    extends $NotifierProvider<FortuneDreamViewModel, FortuneDreamState> {
  FortuneDreamViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fortuneDreamViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fortuneDreamViewModelHash();

  @$internal
  @override
  FortuneDreamViewModel create() => FortuneDreamViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FortuneDreamState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FortuneDreamState>(value),
    );
  }
}

String _$fortuneDreamViewModelHash() =>
    r'8513b9d7802f9f4ca5727b97e77b5bd34e0320fa';

abstract class _$FortuneDreamViewModel extends $Notifier<FortuneDreamState> {
  FortuneDreamState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FortuneDreamState, FortuneDreamState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FortuneDreamState, FortuneDreamState>,
              FortuneDreamState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
