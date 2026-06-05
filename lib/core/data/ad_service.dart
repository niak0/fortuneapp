import 'dart:async';
import 'dart:developer' as developer;

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/ad_ids.dart';

part 'ad_service.g.dart';

// AdMob reklam akışını soyutlayan servis (test'te fake'lenebilir).
abstract class AdService {
  // SDK'yı başlatır ve ilk reklamları önceden yükler.
  Future<void> init();

  // Ödüllü reklam gösterir; izlenirse [onReward] kazanılan miktarla çağrılır.
  // Reklam izlenip ödül kazanıldıysa `true` döner.
  Future<bool> showRewarded({required void Function(int amount) onReward});

  // Geçiş (interstitial) reklam gösterir; hazır değilse sessizce geçer.
  Future<void> showInterstitial();
}

// google_mobile_ads tabanlı production implementasyonu.
class GoogleMobileAdsService implements AdService {
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await MobileAds.instance.initialize();
    _loadRewarded();
    _loadInterstitial();
  }

  // Bir sonraki ödüllü reklamı arka planda yükler.
  void _loadRewarded() {
    RewardedAd.load(
      adUnitId: AdIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          developer.log(
            'Ödüllü reklam yüklenemedi: ${error.message}',
            name: 'ads',
          );
        },
      ),
    );
  }

  // Bir sonraki geçiş reklamını arka planda yükler.
  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          developer.log(
            'Geçiş reklamı yüklenemedi: ${error.message}',
            name: 'ads',
          );
        },
      ),
    );
  }

  @override
  Future<bool> showRewarded({
    required void Function(int amount) onReward,
  }) async {
    final ad = _rewardedAd;
    if (ad == null) {
      _loadRewarded();
      return false;
    }
    _rewardedAd = null;

    final completer = Completer<bool>();
    var earned = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewarded();
        if (!completer.isCompleted) completer.complete(earned);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadRewarded();
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    await ad.show(
      onUserEarnedReward: (_, reward) {
        earned = true;
        onReward(reward.amount.toInt());
      },
    );

    return completer.future;
  }

  @override
  Future<void> showInterstitial() async {
    final ad = _interstitialAd;
    if (ad == null) {
      _loadInterstitial();
      return;
    }
    _interstitialAd = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadInterstitial();
      },
    );

    await ad.show();
  }
}

// AdService DI provider'ı.
@Riverpod(keepAlive: true)
AdService adService(Ref ref) => GoogleMobileAdsService();
