// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_firebase_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mockFirebaseService)
final mockFirebaseServiceProvider = MockFirebaseServiceProvider._();

final class MockFirebaseServiceProvider
    extends
        $FunctionalProvider<
          MockFirebaseService,
          MockFirebaseService,
          MockFirebaseService
        >
    with $Provider<MockFirebaseService> {
  MockFirebaseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mockFirebaseServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mockFirebaseServiceHash();

  @$internal
  @override
  $ProviderElement<MockFirebaseService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MockFirebaseService create(Ref ref) {
    return mockFirebaseService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MockFirebaseService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MockFirebaseService>(value),
    );
  }
}

String _$mockFirebaseServiceHash() =>
    r'f82a6f88c7aa008091afd1ac6d6313c985c55d85';
