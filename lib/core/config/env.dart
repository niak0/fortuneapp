class Env {
  // API Keys
  static const String revenueApiKey = String.fromEnvironment('REVENUE_API_KEY');
  static const String adMobBannerId = String.fromEnvironment('ADMOB_BANNER_ID');
  static const String adMobRewardedId = String.fromEnvironment('ADMOB_REWARDED_ID');
  static const String adMobInterstitialId = String.fromEnvironment('ADMOB_INTERSTITIAL_ID');
  static const String gptApiKey = String.fromEnvironment('GPT_API_KEY');

  static const String users = String.fromEnvironment('FIREBASE_USERS_COLLECTION');
  static const String scheduledJobs = String.fromEnvironment('FIREBASE_SCHEDULED_JOBS_COLLECTION');
  static const String fortunes = String.fromEnvironment('FIREBASE_FORTUNES_COLLECTION');
  static const String gptModel = String.fromEnvironment('GPT_MODEL');
}
