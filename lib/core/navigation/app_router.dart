import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fortuneapp/features/astrology/astrology_view.dart';
import 'package:fortuneapp/features/biorhythm/biorhythm_view.dart';
import 'package:fortuneapp/features/buy_gold/buy_gold_view.dart';
import 'package:fortuneapp/features/fortune_coffee/fortune_coffee_view.dart';
import 'package:fortuneapp/features/fortune_dream/fortune_dream_view.dart';
import 'package:fortuneapp/features/fortune_hand/fortune_hand_view.dart';
import 'package:fortuneapp/features/fortune_tarot/fortune_tarot_view.dart';
import 'package:fortuneapp/features/my_fortunes/my_fortunes_view.dart';
import 'package:fortuneapp/features/navigation_bar/navigation_bar.dart';
import 'package:fortuneapp/features/numerology/helpers/numerology_items.dart';
import 'package:fortuneapp/features/numerology/numerology_detail_view.dart';
import 'package:fortuneapp/features/numerology/numerology_view.dart';
import 'package:fortuneapp/features/profile/profile_view.dart';
import 'package:fortuneapp/features/profile_edit/profile_edit_view.dart';
import 'package:fortuneapp/features/read_fortune/read_fortune_view.dart';
import 'package:fortuneapp/features/settings/settings_view.dart';
import 'package:fortuneapp/features/splash/splash_view.dart';
import 'package:fortuneapp/features/user_setup/user_setup_view.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/auth_bootstrap.dart';
import '../models/fortune_model.dart';

part 'app_router.g.dart';

// Uygulamadaki tüm route'lar — string-path constants gibi kullanılır.
enum AppRoutes {
  splash,
  home,
  fortunes,
  profile,
  userSetupView,
  profileEdit,
  settings,
  buyCredits,
  readFortune,
  fortuneTarot,
  fortuneHand,
  fortuneCoffee,
  fortuneDream,
  biorhythm,
  astrology,
  numerology,
  numerologyDetail,
}

// Enum'dan path string'ine map — `AppRoutes.profileEdit.path` → `/profileEdit`.
extension AppRoutesExtension on AppRoutes {
  String get path => '/$name';
}

// Bootstrap durumu değişince GoRouter'a notify eden basit ChangeNotifier.
class _BootstrapRefreshListenable extends ChangeNotifier {
  void refresh() => notifyListeners();
}

// go_router DI provider'ı — auth state'i ile sync, anon bootstrap'i bekler.
@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  // Bootstrap'i router yaşam süresince ayakta tut (keepAlive listener'sız
  // disposal'ı engeller). Ayrıca bootstrap durumu değişince router'ı yenile.
  final refresh = _BootstrapRefreshListenable();
  ref.listen<AsyncValue<dynamic>>(
    authBootstrapProvider,
    (_, __) => refresh.refresh(),
    fireImmediately: true,
  );
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash.path,
    refreshListenable: refresh,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      // Sadece splash route'unda gate yap; diğer route'larda kullanıcıyı geri çekme.
      if (state.matchedLocation != AppRoutes.splash.path) return null;
      final boot = ref.read(authBootstrapProvider);
      if (boot.hasValue) return AppRoutes.home.path;
      return null; // hâlâ loading veya error — splash'te kal
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash.path,
        builder: (_, __) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.home.path,
        builder: (_, __) => const ProjectNavigationBar(),
      ),
      GoRoute(
        path: AppRoutes.fortunes.path,
        builder: (_, __) => const MyFortunesView(),
      ),
      GoRoute(
        path: AppRoutes.profile.path,
        builder: (_, __) => const ProfileView(),
      ),
      GoRoute(
        path: AppRoutes.userSetupView.path,
        builder: (_, __) => const UserSetupView(),
      ),
      GoRoute(
        path: AppRoutes.profileEdit.path,
        pageBuilder: (_, __) => const MaterialPage(
          fullscreenDialog: true,
          child: ProfileEditView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings.path,
        builder: (_, __) => const SettingsView(),
      ),
      GoRoute(
        path: AppRoutes.buyCredits.path,
        pageBuilder: (_, __) => const MaterialPage(
          fullscreenDialog: true,
          child: BuyGoldView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.readFortune.path,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          final content = args?['currentContent'] as ContentModel?;
          if (content == null) {
            return const MaterialPage(
              child: Scaffold(body: Center(child: Text('Geçersiz argüman'))),
            );
          }
          return MaterialPage(
            fullscreenDialog: true,
            child: ReadFortuneView(currentContent: content),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.fortuneTarot.path,
        builder: (_, __) => const FortuneTarotView(),
      ),
      GoRoute(
        path: AppRoutes.fortuneHand.path,
        builder: (_, __) => const FortuneHandView(),
      ),
      GoRoute(
        path: AppRoutes.fortuneCoffee.path,
        builder: (_, __) => const FortuneCoffeeView(),
      ),
      GoRoute(
        path: AppRoutes.fortuneDream.path,
        builder: (_, __) => const FortuneDreamView(),
      ),
      GoRoute(
        path: AppRoutes.biorhythm.path,
        builder: (_, __) => const BiorhythmView(),
      ),
      GoRoute(
        path: AppRoutes.astrology.path,
        builder: (_, __) => const AstrologyView(),
      ),
      GoRoute(
        path: AppRoutes.numerology.path,
        builder: (_, __) => const NumerologyView(),
      ),
      GoRoute(
        path: AppRoutes.numerologyDetail.path,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          final selectedItem = args?['selectedItem'] as NumerologyItem?;
          final values =
              args?['values'] as Map<NumerologyItem, int>? ?? const {};
          if (selectedItem == null) {
            return const Scaffold(
                body: Center(child: Text('Geçersiz argüman')));
          }
          return NumerologyDetailView(
            selectedItem: selectedItem,
            values: values,
          );
        },
      ),
    ],
  );
}
