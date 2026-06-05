# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Komutlar

- Bağımlılıklar: `flutter pub get`
- Çalıştır: `flutter run`
- Codegen: `dart run build_runner build --delete-conflicting-outputs` (yeni provider ekledikten sonra)
- Codegen watch: `dart run build_runner watch --delete-conflicting-outputs`
- Analiz/lint: `flutter analyze`
- Format: `dart format lib test`
- Tüm testler: `flutter test`
- Tek test: `flutter test test/path/to/file_test.dart --plain-name "test adı"`
- Android build: `flutter build apk` / iOS: `flutter build ios`

## Mimari

Flutter 3.5+ / Dart, **Riverpod 3 + repository pattern** üzerine kurulu feature-based MVVM. `lib/` altında:

- `core/` — paylaşılan altyapı:
  - `auth/` — `auth_notifier.dart` (`@Riverpod(keepAlive: true)` `AuthNotifier`), `current_user.dart` (AsyncNotifier).
  - `config/env.dart` — build-time GPT config (gitignored, `env.example.dart` var).
  - `data/` — **Repository layer** (abstract + Mock impl + provider): `user_repository.dart`, `fortune_repository.dart`, `zodiac_repository.dart`, `auth_repository.dart`. Notifier'lar veri için bunları kullanır, statik `MockService` bağımlılığı yoktur.
  - `models/` — saf data model (`UserModel`, `FortuneModel`, `GptModel`).
  - `navigation/` — `app_router.dart` (`AppRouter` mixin + `AppRoutes` enum + `onGenerateRoute`), `app_navigator.dart` (`AppNavigator` abstract + `RoutingNavigator` impl + `appNavigatorProvider`). Eski `app_navigator_manager.dart` legacy facade (sadece `CustomSnackBar`/`LoadingDialog` statik helper'ları için tutuluyor; UI helper'a tamamen geçince silinecek).
  - `network/` — `gpt_service.dart` (`apiKey`/`model` inject edilir, Env'den provider'da çekilir), `mock_service.dart` (sadece repository içlerinden çağrılır — feature'lar direkt import etmez).
  - `ui/ui_helper.dart` — `UiHelper` abstract + `MaterialUiHelper` impl + provider (`showSnackBar`, `showLoading`, `hideLoading`). Notifier'lar yan etki için bunu kullanır.
  - `utilities/` — `connectivity_service.dart` (StreamNotifier), `gold_manager.dart`, `theme.dart`, `util.dart`.
  - `widgets/` — paylaşılan UI (LoadingDialog/CustomSnackBar legacy statik helper'lar dahil).
- `features/<feature>/` — RIVERPOD.md §2 dosya bölünmesi:
  - `<feature>_state.dart` — composite state class + `copyWith` (sade state için skip).
  - `<feature>_providers.dart` — `@riverpod` class Notifier/AsyncNotifier/StreamNotifier (state dosyasını `export` eder).
  - `<feature>_view.dart` — `ConsumerWidget` / `ConsumerStatefulWidget`.
  - Numerology istisna: `numerology_calculator.dart` (saf hesap class, provider değil).
- `enums/`, `generated/assets.dart` — değişmedi.
- `test/` — `helpers/provider_container_helper.dart`, `helpers/fakes/` (4 fake repository/navigator/ui_helper), feature/core test örnekleri.

### State management — Riverpod 3 + codegen

Tüm provider'lar `@riverpod` / `@Riverpod(keepAlive: true)` annotation'ı ile tanımlanır, `.g.dart` codegen ile üretilir (kural seti: `RIVERPOD.md`). `main.dart` kökü `ProviderScope`, `MultiProvider` yoktur.

**Global `keepAlive` provider'lar:**
- Repository'ler: `userRepositoryProvider`, `fortuneRepositoryProvider`, `zodiacRepositoryProvider`, `authRepositoryProvider`
- Domain notifier'lar: `currentUserProvider`, `authProvider` (AuthNotifier'dan üretilen)
- Servisler: `gptServiceProvider`, `goldManagerProvider`
- Altyapı: `appNavigatorProvider`, `uiHelperProvider`, `connectivityServiceProvider`

**Feature notifier'lar:** autoDispose (varsayılan). Örn. `homeViewModelProvider`, `fortuneTarotViewModelProvider`, `buyGoldViewModelProvider`.

Yeni provider eklerken codegen'i unutma.

### Test-edilebilir mimari

Her dış bağımlılık bir provider arkasında — `ProviderContainer.overrides` ile fake'lerle değiştirilir:

```dart
final container = makeContainer(overrides: [
  userRepositoryProvider.overrideWithValue(FakeUserRepository()),
  appNavigatorProvider.overrideWithValue(FakeNavigator()),
  uiHelperProvider.overrideWithValue(FakeUiHelper()),
]);
final user = await container.read(currentUserProvider.future);
```

`test/helpers/fakes/` altında hazır fake'ler var. Yeni servis eklerken `core/data/` veya `core/ui/` benzeri abstract+impl+provider pattern'ini sürdür.

### Navigasyon — go_router

`MaterialApp.router` + `goRouterProvider` (`lib/core/navigation/app_router.dart`). `GoRouter` `refreshListenable` ile `authStateChanges` stream'ini dinler; bootstrap bitmediyse splash'te bekler, bittiğinde home'a redirect eder. `/login` route YOK — anon auto-login sayesinde gereksiz.

Yeni ekran eklerken:
1. `AppRoutes` enum'una değer ekle (`app_router.dart`).
2. `goRouter` provider'ındaki `routes:` listesine `GoRoute(path: AppRoutes.x.path, builder: ...)` ekle.
3. View/Notifier içinden `ref.read(appNavigatorProvider).pushToPage(AppRoutes.x, arguments: ...)` çağır — argument `state.extra` olarak gelir.

`appNavigatorProvider` (`AppNavigator` abstract) `GoRouterAppNavigator` impl üzerinden çalışır; 35 callsite tek satır değişmeden korunur, test'te `FakeNavigator` ile override edilir. Tam ekran modal'lar `MaterialPage(fullscreenDialog: true, ...)` ile tanımlanır (`buyCredits`, `profileEdit`, `readFortune`).

### Auth — Firebase (Anonymous-first + Google/Apple linking)

App açılışında `authBootstrapProvider` Firebase anonymous login yapar (yoksa). UID hemen üretilir, kullanıcı arayüzü hiç bir login ekranı görmeden home'a düşer.

Anasayfada `SignUpPromptBanner` (`features/home/widgets/sign_up_prompt_banner.dart`) anon kullanıcılara "verileriniz kaybolabilir, lütfen giriş yapın" uyarısı çıkarır. Tıklanca `SignInSheet` (bottom sheet) açılır → Apple / Google. OAuth flow'unda `FirebaseAuthRepository._signInOrLink` anon kullanıcıyı **`linkWithCredential`** ile upgrade eder; **UID korunur**, Firestore'daki coin/fal verisi kaybolmaz.

`authProvider` (`AuthNotifier`) → `AuthUser?` (uid + isAnonymous + providerIds). View'lar `ref.watch(authProvider.select((u) => u?.isAnonymous))` ile reactif izler.

Settings → Çıkış Yap → `authRepository.signOut()` → bootstrap yeni anon login yapar → banner geri gelir.

**Native config (kullanıcı tarafından manuel):**
- iOS `Info.plist`: `CFBundleURLTypes` içine `REVERSED_CLIENT_ID` koy (placeholder ile boş bırakıldı). Firebase Console → Authentication → Google Sign-In aktif et → yeni `GoogleService-Info.plist` indir → değeri kopyala.
- iOS `Runner.entitlements`: `com.apple.developer.applesignin` zaten ekli ✓.
- Apple Developer Console → App ID'de Sign in with Apple capability + Service ID + key setup.
- Android: Firebase Console → Project Settings → SHA-1 ekle (`keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`). Google + Apple + Anonymous provider'ları Authentication panelinden aktif et.

### Bağlantı kontrolü

`MyApp.build` içinde `ref.watch(connectivityServiceProvider).maybeWhen(...)` çocuğu sarar; bağlantı yoksa `NoInternetDialog` gösterilir. Bu davranışı bypass eden ekran ekleme.

### GPT / Firebase

`GptService` `dio` ile çağrı yapar; `apiKey`/`model` `Env.*`'tan provider seviyesinde inject edilir. Firebase tarafı şu an **repository pattern arkasındaki mock**'larla çalışıyor — gerçek `cloud_firestore`/`firebase_auth` wire'lı değil. Gerçek Firebase'e geçerken sadece `core/data/*_repository.dart` Mock impl'leri yerine `FirestoreUserRepository` vb. yazıp provider'ları override etmek yeterli.

## Stil notları (yerel)

- Lint: `package:flutter_lints/flutter.yaml` + `riverpod_lint` (custom_lint plugin'i `analysis_options.yaml`'da aktif).
- Türkçe tek satır açıklama her class/function/view/notifier'ın başına eklenir (global CLAUDE.md kuralı).
- Dosya isimleri `snake_case`; feature deseni `*_view.dart` / `*_providers.dart` / `*_state.dart`.
- Yeni dependency: `flutter pub add <pkg>`. Provider/Riverpod paketi varsayılan **flutter_riverpod 3.x + riverpod_annotation 4.x**.
