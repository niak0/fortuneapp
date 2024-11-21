import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fortuneapp/features/fortune_tarot/tarot_model.dart';
import '../../core/models/user_model.dart';

class FortuneTarotViewModel extends ChangeNotifier {
  List<CardModel>? cards;

  final UserModel currentUser;

  FortuneTarotViewModel(this.currentUser);

  Map<String, int?> selectedCards = {
    "Geçmiş": null,
    "Şimdi": null,
    "Gelecek": null,
  };
  double angle = 0.0;

  void initCards() async {
    final jsonString = await rootBundle.loadString('assets/tarot/tarot-images.json');
    final Map<String, dynamic> jsonResponse = json.decode(jsonString);
    cards = (jsonResponse['cards'] as List).map((card) => CardModel.fromMap(card)).toList();
    notifyListeners();
  }

  void rotateWheel(double rotationAngle) {
    angle += rotationAngle;
    notifyListeners();
  }

  void handleTapOnCard() {
    if (cards?.isNotEmpty ?? false) {
      int randomIndex;
      do {
        randomIndex = Random().nextInt(cards!.length);
      } while (selectedCards.containsValue(randomIndex)); // Daha önce seçilmemiş kart bulunana kadar döner

      // Boş olan ilk alanı bul
      String? nextEmptyArea = selectedCards.entries.firstWhere((entry) => entry.value == null, orElse: () => const MapEntry("", null)).key;

      if (nextEmptyArea.isNotEmpty) {
        selectedCards[nextEmptyArea] = randomIndex;
        notifyListeners();
      }
    }
  }

  Future<void> handleSelectedCards() async {
    // Mock işlem
    await Future.delayed(const Duration(seconds: 2));
  }
}
