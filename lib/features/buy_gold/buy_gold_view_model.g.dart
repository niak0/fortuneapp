// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buy_gold_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BuyGoldViewModel)
final buyGoldViewModelProvider = BuyGoldViewModelProvider._();

final class BuyGoldViewModelProvider
    extends $AsyncNotifierProvider<BuyGoldViewModel, void> {
  BuyGoldViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'buyGoldViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$buyGoldViewModelHash();

  @$internal
  @override
  BuyGoldViewModel create() => BuyGoldViewModel();
}

String _$buyGoldViewModelHash() => r'568387dc5d01780c223849a6df3b340f7b8e96b7';

abstract class _$BuyGoldViewModel extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
