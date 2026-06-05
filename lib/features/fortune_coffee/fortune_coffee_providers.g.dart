// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fortune_coffee_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FortuneCoffeeViewModel)
final fortuneCoffeeViewModelProvider = FortuneCoffeeViewModelProvider._();

final class FortuneCoffeeViewModelProvider
    extends $NotifierProvider<FortuneCoffeeViewModel, FortuneCoffeeState> {
  FortuneCoffeeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fortuneCoffeeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fortuneCoffeeViewModelHash();

  @$internal
  @override
  FortuneCoffeeViewModel create() => FortuneCoffeeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FortuneCoffeeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FortuneCoffeeState>(value),
    );
  }
}

String _$fortuneCoffeeViewModelHash() =>
    r'1cba01d72acffa566401c03e4a02780ef57a15d3';

abstract class _$FortuneCoffeeViewModel extends $Notifier<FortuneCoffeeState> {
  FortuneCoffeeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FortuneCoffeeState, FortuneCoffeeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FortuneCoffeeState, FortuneCoffeeState>,
              FortuneCoffeeState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
