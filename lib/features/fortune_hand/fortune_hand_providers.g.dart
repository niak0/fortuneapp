// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fortune_hand_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FortuneHandViewModel)
final fortuneHandViewModelProvider = FortuneHandViewModelProvider._();

final class FortuneHandViewModelProvider
    extends $NotifierProvider<FortuneHandViewModel, FortuneHandState> {
  FortuneHandViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fortuneHandViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fortuneHandViewModelHash();

  @$internal
  @override
  FortuneHandViewModel create() => FortuneHandViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FortuneHandState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FortuneHandState>(value),
    );
  }
}

String _$fortuneHandViewModelHash() =>
    r'6be65bbbc51ac0c60e96987d963ea667333fc012';

abstract class _$FortuneHandViewModel extends $Notifier<FortuneHandState> {
  FortuneHandState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FortuneHandState, FortuneHandState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FortuneHandState, FortuneHandState>,
              FortuneHandState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
