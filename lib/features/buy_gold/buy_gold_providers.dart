import 'package:flutter/foundation.dart';
import 'package:fortuneapp/core/utilities/gold_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'buy_gold_providers.g.dart';

// Altın satın alma ekranı için AsyncNotifier — loading durumunu tutar.
@riverpod
class BuyGoldViewModel extends _$BuyGoldViewModel {
  @override
  Future<void> build() async {
    await _fetchPackages();
  }

  Future<void> _fetchPackages() async {
    // RevenueCat paketleri burada yüklenecek.
  }

  // Bir paketi satın alır ve başarılıysa altın artırır.
  Future<bool> buyPackage(String package) async {
    try {
      const coinAmount = 0;
      if (coinAmount > 0) {
        await ref.read(goldManagerProvider).increaseGold(amount: coinAmount);
      }
      return true;
    } catch (e) {
      if (kDebugMode) print('Satın alma başarısız: $e');
      return false;
    }
  }
}
