import 'dart:io';

import 'package:flutter/foundation.dart';

import 'env.dart';

// Platforma ve build moduna göre AdMob unit ID'lerini sağlayan yardımcı.
//
// Debug/profile modunda Google'ın resmi test ID'leri kullanılır (banlanma
// riski yok). Release modunda `Env.*`'tan gelen gerçek ID'ler kullanılır;
// boşsa güvenli tarafta kalmak için yine test ID'sine düşülür.
class AdIds {
  const AdIds._();

  // true iken (release dahil) tüm reklam unit'leri Google test ID'sinde kalır.
  // Gerçek reklamları yayınlamaya hazır olunca false yap. App ID native
  // dosyalarda zaten gerçek değerle ayarlı; bu flag yalnızca unit ID'leri etkiler.
  static const bool _forceTestAds = true;

  // Google resmi test ID'leri (https://developers.google.com/admob).
  static const _testRewardedAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const _testRewardedIos = 'ca-app-pub-3940256099942544/1712485313';
  static const _testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const _testInterstitialIos =
      'ca-app-pub-3940256099942544/4411468910';

  // Ödüllü reklam unit ID'si.
  static String get rewarded {
    if (!_forceTestAds && kReleaseMode && Env.adMobRewardedId.isNotEmpty) {
      return Env.adMobRewardedId;
    }
    return Platform.isIOS ? _testRewardedIos : _testRewardedAndroid;
  }

  // Geçiş (interstitial) reklam unit ID'si.
  static String get interstitial {
    if (!_forceTestAds && kReleaseMode && Env.adMobInterstitialId.isNotEmpty) {
      return Env.adMobInterstitialId;
    }
    return Platform.isIOS ? _testInterstitialIos : _testInterstitialAndroid;
  }
}
