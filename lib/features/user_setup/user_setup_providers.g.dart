// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_setup_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserSetupViewModel)
final userSetupViewModelProvider = UserSetupViewModelProvider._();

final class UserSetupViewModelProvider
    extends $NotifierProvider<UserSetupViewModel, UserSetupState> {
  UserSetupViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSetupViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSetupViewModelHash();

  @$internal
  @override
  UserSetupViewModel create() => UserSetupViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserSetupState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserSetupState>(value),
    );
  }
}

String _$userSetupViewModelHash() =>
    r'35b9ffd36174ed8a03e3d61e6ebe15c0d26d090a';

abstract class _$UserSetupViewModel extends $Notifier<UserSetupState> {
  UserSetupState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UserSetupState, UserSetupState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserSetupState, UserSetupState>,
              UserSetupState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
