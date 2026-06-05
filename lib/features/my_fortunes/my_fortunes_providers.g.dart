// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_fortunes_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyFortunesViewModel)
final myFortunesViewModelProvider = MyFortunesViewModelProvider._();

final class MyFortunesViewModelProvider
    extends $StreamNotifierProvider<MyFortunesViewModel, List<FortuneModel>> {
  MyFortunesViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myFortunesViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myFortunesViewModelHash();

  @$internal
  @override
  MyFortunesViewModel create() => MyFortunesViewModel();
}

String _$myFortunesViewModelHash() =>
    r'4ba41579ab1db07e10576b8206b45d84790c88c0';

abstract class _$MyFortunesViewModel
    extends $StreamNotifier<List<FortuneModel>> {
  Stream<List<FortuneModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<FortuneModel>>, List<FortuneModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<FortuneModel>>, List<FortuneModel>>,
              AsyncValue<List<FortuneModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
