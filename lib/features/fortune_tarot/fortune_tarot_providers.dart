import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';
import 'package:fortuneapp/features/fortune_tarot/tarot_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/auth/current_user.dart';
import '../../core/data/fortune_repository.dart';
import '../../core/network/prompt_builder.dart';
import '../../core/ui/ui_helper.dart';
import '../../core/utilities/gold_manager.dart';
import 'fortune_tarot_state.dart';

export 'fortune_tarot_state.dart';

part 'fortune_tarot_providers.g.dart';

// Tarot çekme akışı için AsyncNotifier — kart JSON'unu yükler.
@riverpod
class FortuneTarotViewModel extends _$FortuneTarotViewModel {
  @override
  Future<FortuneTarotState> build() async {
    final jsonString = await rootBundle.loadString(
      'assets/tarot/tarot-images.json',
    );
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

  // Seçilen kartlardan bekleyen bir fal oluşturur; yorum arka planda üretilir.
  Future<bool> handleSelectedCards() async {
    final current = state.value;
    final cards = current?.cards;
    if (current == null || cards == null) return false;

    final user = ref.read(currentUserProvider).value;
    if (user == null) return false;

    final ui = ref.read(uiHelperProvider);
    final gold = ref.read(goldManagerProvider);
    if (!gold.checkGoldAndProceed(kFortuneCost)) {
      ui.showSnackBar('Yeterli altının yok');
      return false;
    }

    final selected = current.selectedCards.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}: ${cards[e.value!].name}')
        .join(', ');

    // Altını şimdi düş; üretim Cloud Function'da arka planda yapılacak.
    await gold.decreaseGold(kFortuneCost);
    final ok = await ref
        .read(fortuneRepositoryProvider)
        .create(
          contentType: ContentType.tarot,
          request: {'userContext': buildUserContext(user), 'cards': selected},
        );
    if (!ok) {
      await gold.increaseGold(amount: kFortuneCost);
      ui.showSnackBar('Fal başlatılamadı, lütfen tekrar dene');
      return false;
    }

    ui.showSnackBar('Falın hazırlanıyor, birazdan hazır olacak ✨');
    return true;
  }
}
