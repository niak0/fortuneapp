import 'package:fortuneapp/core/auth/current_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gold_manager.g.dart';

// Bir fal oluşturmanın altın maliyeti (tüm fal akışları paylaşır).
const kFortuneCost = 1;

// Altın kontrol/işlem mantığını CurrentUser'a delege eden servis.
class GoldManager {
  GoldManager(this._ref);
  final Ref _ref;

  // Kullanıcının `requiredAmount` kadar altını var mı?
  bool checkGoldAndProceed(int requiredAmount) {
    final user = _ref.read(currentUserProvider).value;
    return (user?.coin ?? 0) >= requiredAmount;
  }

  // Mevcut kullanıcıya altın ekler.
  Future<void> increaseGold({required int amount}) async {
    await _ref.read(currentUserProvider.notifier).incrementGold(amount: amount);
  }

  // Mevcut kullanıcıdan `amount` (varsayılan 1) altın düşer.
  Future<void> decreaseGold([int amount = 1]) async {
    await _ref.read(currentUserProvider.notifier).decrementGold(amount);
  }
}

// GoldManager DI provider'ı.
@Riverpod(keepAlive: true)
GoldManager goldManager(Ref ref) => GoldManager(ref);
