import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:fortuneapp/features/fortune_tarot/tarot_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'fortune_tarot_state.dart';

export 'fortune_tarot_state.dart';

part 'fortune_tarot_providers.g.dart';

// Tarot çekme akışı için AsyncNotifier — kart JSON'unu yükler.
@riverpod
class FortuneTarotViewModel extends _$FortuneTarotViewModel {
  @override
  Future<FortuneTarotState> build() async {
    final jsonString =
        await rootBundle.loadString('assets/tarot/tarot-images.json');
    final Map<String, dynamic> jsonResponse = json.decode(jsonString);
    final cards = (jsonResponse['cards'] as List)
        .map((card) => CardModel.fromMap(card))
        .toList();
    return FortuneTarotState.initial().copyWith(cards: cards);
  }

  // Çarkı verilen açı kadar döndürür.
  void rotateWheel(double rotationAngle) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(angle: current.angle + rotationAngle));
  }

  // Kart seçim slot'una rastgele bir kart yerleştirir.
  void handleTapOnCard() {
    final current = state.value;
    if (current == null) return;
    final cards = current.cards;
    if (cards == null || cards.isEmpty) return;

    int randomIndex;
    do {
      randomIndex = Random().nextInt(cards.length);
    } while (current.selectedCards.containsValue(randomIndex));

    final nextEmptyArea = current.selectedCards.entries
        .firstWhere(
          (entry) => entry.value == null,
          orElse: () => const MapEntry('', null),
        )
        .key;
    if (nextEmptyArea.isEmpty) return;

    final updated = Map<String, int?>.from(current.selectedCards);
    updated[nextEmptyArea] = randomIndex;
    state = AsyncData(current.copyWith(selectedCards: updated));
  }

  // Seçilen kartları işler (mock async).
  Future<void> handleSelectedCards() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
