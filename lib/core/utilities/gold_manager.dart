import 'package:fortuneapp/core/models/current_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gold_manager.g.dart';

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
    _ref.read(currentUserProvider.notifier).incrementGold(amount: amount);
  }

  // Mevcut kullanıcıdan 1 altın düşer.
  Future<void> decreaseGold() async {
    _ref.read(currentUserProvider.notifier).decrementGold(1);
  }
}

// GoldManager DI provider'ı.
@Riverpod(keepAlive: true)
GoldManager goldManager(Ref ref) => GoldManager(ref);
