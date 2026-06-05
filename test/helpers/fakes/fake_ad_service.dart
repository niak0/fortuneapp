import 'package:fortuneapp/core/data/ad_service.dart';

// Reklam çağrılarını yakalayan, ödülü konfigüre edilebilir fake.
class FakeAdService implements AdService {
  FakeAdService({this.rewardEarned = true, this.rewardAmount = 1});

  // showRewarded'ın ödül kazandırıp kazandırmadığını belirler.
  bool rewardEarned;
  // Ödül kazanıldığında onReward'a verilecek miktar.
  int rewardAmount;

  int initCount = 0;
  int rewardedShowCount = 0;
  int interstitialShowCount = 0;

  @override
  Future<void> init() async => initCount++;

  @override
  Future<bool> showRewarded({
    required void Function(int amount) onReward,
  }) async {
    rewardedShowCount++;
    if (rewardEarned) onReward(rewardAmount);
    return rewardEarned;
  }

  @override
  Future<void> showInterstitial() async => interstitialShowCount++;
}
