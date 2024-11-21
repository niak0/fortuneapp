import 'package:fortuneapp/core/network/mock_firebase_service.dart';
import '../models/current_user.dart';

class GoldManager {
  GoldManager({required this.firebaseService, required this.currentUser});

  final CurrentUser currentUser;
  final MockFirebaseService firebaseService;

  /// Altın miktarını kontrol eder ve işlem yapılabilir mi bakar
  bool checkGoldAndProceed(int requiredAmount) => currentUser.currentUser!.coin >= requiredAmount;

  /// Kullanıcıya altın ekleme işlemi
  Future<void> increaseGold({required int amount}) async {
    currentUser.incrementGold(amount: amount); // Local olarak güncelleme
  }

  /// Altını azaltma işlemi
  Future<void> decreaseGold() async {
    currentUser.decrementGold(1); // Local olarak güncelleme
  }
}
