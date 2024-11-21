import 'package:flutter/foundation.dart';
import 'package:fortuneapp/core/utils/gold_manager.dart';

class BuyGoldViewModel extends ChangeNotifier {
  bool isLoading = true;
  final GoldManager goldManager;
  BuyGoldViewModel(this.goldManager);

  Future<void> initializeRevenueCat() async {
    await _fetchPackages();
    isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchPackages() async {
    try {
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Paketleri yüklerken hata: $e");
      }
    }
  }

  Future<bool> buyPackage(String package) async {
    try {
      int coinAmount = 0;

      // Satın alınan pakete göre altın miktarını ayarla

      if (coinAmount > 0) {
        goldManager.increaseGold(amount: coinAmount);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Satın alma başarısız: $e");
      }
      return false;
    }
  }
}
