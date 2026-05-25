// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_edit_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileEditViewModel)
final profileEditViewModelProvider = ProfileEditViewModelProvider._();

final class ProfileEditViewModelProvider
    extends $NotifierProvider<ProfileEditViewModel, UserModel?> {
  ProfileEditViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileEditViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileEditViewModelHash();

  @$internal
  @override
  ProfileEditViewModel create() => ProfileEditViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserModel?>(value),
    );
  }
}

String _$profileEditViewModelHash() =>
    r'd7998b7c8198006560764f5696ee1b9774b0c8a6';

abstract class _$ProfileEditViewModel extends $Notifier<UserModel?> {
  UserModel? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UserModel?, UserModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserModel?, UserModel?>,
              UserModel?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
