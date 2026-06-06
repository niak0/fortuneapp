// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biorhythm_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BiorhythmViewModel)
final biorhythmViewModelProvider = BiorhythmViewModelFamily._();

final class BiorhythmViewModelProvider
    extends $NotifierProvider<BiorhythmViewModel, DayItems> {
  BiorhythmViewModelProvider._({
    required BiorhythmViewModelFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'biorhythmViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$biorhythmViewModelHash();

  @override
  String toString() {
    return r'biorhythmViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BiorhythmViewModel create() => BiorhythmViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DayItems value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DayItems>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BiorhythmViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$biorhythmViewModelHash() =>
    r'51647901b9ee103060bd661abc0baa448c7e6065';

final class BiorhythmViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          BiorhythmViewModel,
          DayItems,
          DayItems,
          DayItems,
          DateTime
        > {
  BiorhythmViewModelFamily._()
    : super(
        retry: null,
        name: r'biorhythmViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BiorhythmViewModelProvider call({required DateTime birthDate}) =>
      BiorhythmViewModelProvider._(argument: birthDate, from: this);

  @override
  String toString() => r'biorhythmViewModelProvider';
}

abstract class _$BiorhythmViewModel extends $Notifier<DayItems> {
  late final _$args = ref.$arg as DateTime;
  DateTime get birthDate => _$args;

  DayItems build({required DateTime birthDate});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DayItems, DayItems>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DayItems, DayItems>,
              DayItems,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(birthDate: _$args));
  }
}
