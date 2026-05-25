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
    extends $StreamNotifierProvider<MyFortunesViewModel, List<ContentModel>> {
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
    r'4400ad7cd266e7e8c68242b5d0b73dd7f297cb1f';

abstract class _$MyFortunesViewModel
    extends $StreamNotifier<List<ContentModel>> {
  Stream<List<ContentModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ContentModel>>, List<ContentModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ContentModel>>, List<ContentModel>>,
              AsyncValue<List<ContentModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
