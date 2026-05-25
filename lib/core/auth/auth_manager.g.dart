// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthManager)
final authManagerProvider = AuthManagerProvider._();

final class AuthManagerProvider extends $NotifierProvider<AuthManager, bool> {
  AuthManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authManagerHash();

  @$internal
  @override
  AuthManager create() => AuthManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$authManagerHash() => r'a9537fa8203d38d1cb884bdd33fbb598aea5830f';

abstract class _$AuthManager extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
