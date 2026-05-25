import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/mock_service.dart';
import 'zodiac_model.dart';
import 'zodiac_view.dart';

part 'zodiac_view_model.g.dart';

// Burç ekranının state'i — yüklü burçlar, seçili burç, seçili segment.
class ZodiacState {
  final List<ZodiacModel> zodiacModels;
  final ZodiacModel? selectedZodiac;
  final ZodiacSegments selectedSegment;

  const ZodiacState({
    required this.zodiacModels,
    required this.selectedZodiac,
    required this.selectedSegment,
  });

  ZodiacState copyWith({
    List<ZodiacModel>? zodiacModels,
    ZodiacModel? selectedZodiac,
    ZodiacSegments? selectedSegment,
  }) =>
      ZodiacState(
        zodiacModels: zodiacModels ?? this.zodiacModels,
        selectedZodiac: selectedZodiac ?? this.selectedZodiac,
        selectedSegment: selectedSegment ?? this.selectedSegment,
      );
}

// Burç verilerini mock servisten yükleyen AsyncNotifier.
@riverpod
class ZodiacViewModel extends _$ZodiacViewModel {
  @override
  Future<ZodiacState> build() async {
    final data = await MockService.getZodiacModels();
    final models = data
        .map((json) => ZodiacModel(
              sign: json['sign'],
              planet: json['planet'],
              element: json['element'],
              dateRange: json['dateRange'],
              loveScore: json['loveScore'],
              healthScore: json['healthScore'],
              moneyScore: json['moneyScore'],
              motto: json['motto'],
              commentYesterday: json['commentYesterday'],
              commentDaily: json['commentDaily'],
              commentWeekly: json['commentWeekly'],
              commentMonthly: json['commentMonthly'],
              commentYearly: json['commentYearly'],
            ))
        .toList();
    return ZodiacState(
      zodiacModels: models,
      selectedZodiac: models.isNotEmpty ? models.first : null,
      selectedSegment: ZodiacSegments.week,
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
