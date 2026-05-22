# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Komutlar

- Bağımlılıklar: `flutter pub get`
- Çalıştır: `flutter run`
- Analiz/lint: `flutter analyze`
- Format: `dart format lib test`
- Tüm testler: `flutter test`
- Tek test: `flutter test test/path/to/file_test.dart --plain-name "test adı"`
- Android build: `flutter build apk` / iOS: `flutter build ios`

## Mimari

Flutter 3.5+ / Dart üzerinde, **MVVM benzeri feature-based** yapı. `lib/` altında:

- `core/` — paylaşılan altyapı:
  - `auth/` — `AuthManager` + `AuthService` arayüzü, şu an `MockAuthService` aktif.
  - `network/` — `GptService` (dio tabanlı), `MockFirebaseService`, `mock_service.dart`. **Uygulama mock veriyle çalışır**, gerçek backend bağlantısı yoktur (README).
  - `navigation/` — `AppNavigator` mixin'i `onGenerateRoute` ile `AppRoutes` enum'unu eşler; `AppNavigatorManager` global `navigatorKey` tutar (context-suz navigasyon).
  - `logic/`, `utils/` — `GoldController`, `GoldManager`, `ConnectivityService`, `AppInitializer` (uygulama açılışında `AppInitializer.init(context)` üzerinden başlatılır).
  - `models/` — `CurrentUser` (ChangeNotifier), `UserModel`, `FortuneModel`, `GptModel`.
  - `utilitys/theme.dart` — `MaterialTheme` ve `createTextTheme` (Roboto). Uygulama yalnızca `theme.dark()` ile başlatılıyor.
  - `widgets/` — paylaşılan UI (loading, snackbar, shimmer, custom button vb.).
- `features/<feature>/` — her özellik kendi `*_view.dart`, `*_view_model.dart` (+ bazen `*_view_mixin.dart`, `helpers/`) dosyalarını içerir. Özellikler: home, splash, log_in, user_setup, profile(+edit), settings, navigation_bar, sider_bar, my_fortunes, buy_gold, fortune_tarot / coffee / hand / dream, read_fortune, astrology, biorhythm, numerology.
- `enums/` — domain enum'ları (`FortuneTopic`, `ZodiacSign`, `GptContentType`, vb.).
- `generated/assets.dart` — asset sabitleri (elle kullanın, override etmeyin).

### State management — projeye özel istisna
Global kuralın aksine bu proje **Riverpod değil, `provider: ^6.x` kullanır**. `main.dart` içindeki `MultiProvider` köktür: `MockFirebaseService`, `GptService`, `ConnectivityService`, `CurrentUser`, `AuthManager`, `GoldManager`, `GoldController`. Yeni servis eklerken Riverpod'a geçirme; mevcut MultiProvider'a Provider/ChangeNotifierProvider olarak ekleyin. Bağımlılıklar provider zincirinden çözülür (örn. `GoldManager` `MockFirebaseService` + `CurrentUser` alır).

### Navigasyon
`MaterialApp.onGenerateRoute: onGenerateRoute` (`AppNavigator` mixin'inden gelir). Yeni ekran eklerken:
1. `AppRoutes` enum'una değer ekleyin.
2. `app_navigator.dart` switch'ine `_navigateToNormal(...)` case'i ekleyin.
3. Argüman gerekiyorsa `routeSettings.arguments` Map olarak parse edilir (örn. `readFortune`).

Tam ekran modal'lar `isFullScreenDialog: true` ile açılır (örn. `buyCredits`, `profileEdit`).

### Bağlantı kontrolü
`MyApp.build` içinde `Consumer<ConnectivityService>` tüm child'ı sarar; bağlantı yoksa `NoInternetDialog` gösterilir. Bu davranışı bypass eden ekran eklemeyin.

### GPT / Firebase
`GptService` `dio` ile çağrı yapar; üretimde `core/config/env.dart` (gitignored, `env.example.dart` var) ile API anahtarı sağlanır. Firebase çağrıları `MockFirebaseService` üzerinden simüle edilir — gerçek Firebase wire'lanmamıştır, `firebase-debug.log` artık.

## Stil notları (yerel)

- Lint: `package:flutter_lints/flutter.yaml` (analysis_options.yaml). Ek kural yok.
- Türkçe tek satır açıklama her class/function/view'in başına eklenir (global CLAUDE.md kuralı).
- Dosya isimleri `snake_case`, `*_view.dart` / `*_view_model.dart` deseni korunmalı.
- Yeni dependency eklerken `flutter pub add <pkg>` kullanın.
