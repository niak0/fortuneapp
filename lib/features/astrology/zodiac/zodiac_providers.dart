import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/zodiac_repository.dart';
import 'zodiac_model.dart';
import 'zodiac_state.dart';
import 'zodiac_view.dart';

export 'zodiac_state.dart';

part 'zodiac_providers.g.dart';

// Burç verilerini mock servisten yükleyen AsyncNotifier.
@riverpod
class ZodiacViewModel extends _$ZodiacViewModel {
  @override
  Future<ZodiacState> build() async {
    final models = await ref.watch(zodiacRepositoryProvider).fetchAll();
    return ZodiacState(
      zodiacModels: models,
      selectedZodiac: models.isNotEmpty ? models.first : null,
      selectedSegment: ZodiacSegments.day,
    );
  }

  // Aktif burcu değiştirir.
  void setSelectedZodiac(ZodiacModel zodiac) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedZodiac: zodiac));
  }

  // Seçili zaman dilimini değiştirir.
  void setSelectedSegment(ZodiacSegments segment) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedSegment: segment));
  }
}
