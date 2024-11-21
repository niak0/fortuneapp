import '../utils/gold_manager.dart';

class GoldController {
  final GoldManager goldManager;

  GoldController(this.goldManager);

  Future<void> increaseGold({required int amount}) async {
    await goldManager.increaseGold(amount: amount);
  }

  Future<void> decreaseGold() async {
    await goldManager.decreaseGold();
  }
}
