import 'package:fortuneapp/core/utils/gold_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gold_controller.g.dart';

// GoldManager üzerine ince bir delegasyon katmanı.
class GoldController {
  GoldController(this.goldManager);
  final GoldManager goldManager;

  Future<void> increaseGold({required int amount}) =>
      goldManager.increaseGold(amount: amount);

  Future<void> decreaseGold() => goldManager.decreaseGold();
}

// GoldController DI provider'ı.
@Riverpod(keepAlive: true)
GoldController goldController(Ref ref) =>
    GoldController(ref.watch(goldManagerProvider));
