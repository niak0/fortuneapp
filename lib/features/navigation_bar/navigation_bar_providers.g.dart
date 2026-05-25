// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_bar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NavigationBarViewModel)
final navigationBarViewModelProvider = NavigationBarViewModelProvider._();

final class NavigationBarViewModelProvider
    extends $NotifierProvider<NavigationBarViewModel, int> {
  NavigationBarViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'navigationBarViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$navigationBarViewModelHash();

  @$internal
  @override
  NavigationBarViewModel create() => NavigationBarViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$navigationBarViewModelHash() =>
    r'be0b79e03b472dbbcbc2c4bca85d6b629b3db7f8';

abstract class _$NavigationBarViewModel extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
