import 'tarot_model.dart';

// Tarot ekranının state'i: yüklenen kartlar, seçilenler, çark açısı.
class FortuneTarotState {
  final List<CardModel>? cards;
  final Map<String, int?> selectedCards;
  final double angle;

  const FortuneTarotState({
    required this.cards,
    required this.selectedCards,
    required this.angle,
  });

  factory FortuneTarotState.initial() => const FortuneTarotState(
        cards: null,
        selectedCards: {'Geçmiş': null, 'Şimdi': null, 'Gelecek': null},
        angle: 0.0,
      );

  FortuneTarotState copyWith({
    List<CardModel>? cards,
    Map<String, int?>? selectedCards,
    double? angle,
  }) =>
      FortuneTarotState(
        cards: cards ?? this.cards,
        selectedCards: selectedCards ?? this.selectedCards,
        angle: angle ?? this.angle,
      );
}
