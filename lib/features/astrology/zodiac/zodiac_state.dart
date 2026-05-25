import 'zodiac_model.dart';
import 'zodiac_view.dart';

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
