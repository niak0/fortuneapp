// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fortune_refund_watcher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FortuneRefundWatcher)
final fortuneRefundWatcherProvider = FortuneRefundWatcherProvider._();

final class FortuneRefundWatcherProvider
    extends $NotifierProvider<FortuneRefundWatcher, void> {
  FortuneRefundWatcherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fortuneRefundWatcherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fortuneRefundWatcherHash();

  @$internal
  @override
  FortuneRefundWatcher create() => FortuneRefundWatcher();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$fortuneRefundWatcherHash() =>
    r'57e1bdf69e4254a184842a68dc8d6671414f5654';

abstract class _$FortuneRefundWatcher extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
