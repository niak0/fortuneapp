import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fortuneapp/features/navigation_bar/navigation_bar.dart';
import 'package:fortuneapp/features/numerology/helpers/numerology_items.dart';
import 'package:fortuneapp/features/astrology/astrology_view.dart';
import 'package:fortuneapp/features/biorhythm/biorhythm_view.dart';
import 'package:fortuneapp/features/buy_gold/buy_gold_view.dart';
import 'package:fortuneapp/features/fortune_coffee/fortune_coffee_view.dart';
import 'package:fortuneapp/features/fortune_hand/fortune_hand_view.dart';
import 'package:fortuneapp/features/fortune_tarot/fortune_tarot_view.dart';
import 'package:fortuneapp/features/log_in/view/sign_in_view.dart';
import 'package:fortuneapp/features/my_fortunes/my_fortunes_view.dart';
import 'package:fortuneapp/features/numerology/numerology_detail_view.dart';
import 'package:fortuneapp/features/numerology/numerology_view.dart';
import 'package:fortuneapp/features/profile/profile_view.dart';
import 'package:fortuneapp/features/profile_edit/profile_edit_view.dart';
import 'package:fortuneapp/features/read_fortune/read_fortune_view.dart';
import 'package:fortuneapp/features/settings/settings_view.dart';
import 'package:fortuneapp/features/user_setup/user_setup_view.dart';
import 'package:fortuneapp/main.dart';
import '../../features/fortune_dream/fortune_dream_view.dart';
import '../../features/splash/splash_view.dart';
import '../../core/models/fortune_model.dart';

mixin AppNavigator<T extends MyApp> on Widget {
  Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    final routeName = routeSettings.name ?? '/';
    final routes = routeSettings.name == '/' ? AppRoutes.splash : AppRoutes.values.byName(routeName.replaceFirst('/', ''));

    switch (routes) {
      case AppRoutes.splash:
        return _navigateToNormal(const SplashView());
      case AppRoutes.login:
        return _navigateToNormal(const SignInView());
      case AppRoutes.home:
        if (kDebugMode) {
          print("initialRoute");
        }
        return _navigateToNormal(const ProjectNavigationBar());
      case AppRoutes.fortunes:
        return _navigateToNormal(const MyFortunesView());
      case AppRoutes.profile:
        return _navigateToNormal(const ProfileView());
      case AppRoutes.userSetupView:
        return _navigateToNormal(const UserSetupView());
      case AppRoutes.profileEdit:
        return _navigateToNormal(const ProfileEditView(), isFullScreenDialog: true);
      case AppRoutes.settings:
        return _navigateToNormal(const SettingsView());
      case AppRoutes.buyCredits:
        return _navigateToNormal(const BuyGoldView(), isFullScreenDialog: true);
      case AppRoutes.readFortune:
        if (routeSettings.arguments is Map<String, dynamic>) {
          final args = routeSettings.arguments as Map<String, dynamic>;
          final currentContent = args['currentContent'] as ContentModel;
          return _navigateToNormal(ReadFortuneView(currentContent: currentContent), isFullScreenDialog: true);
        } else {
          if (kDebugMode) {
            print("Error: Arguments are not of type Map<String, dynamic>");
          }
          return null;
        }
      case AppRoutes.fortuneCoffee:
        return _navigateToNormal(FortuneCoffeeView(), isFullScreenDialog: true);
      case AppRoutes.fortuneTarot:
        return _navigateToNormal(const FortuneTarotView(), isFullScreenDialog: true);
      case AppRoutes.fortuneHand:
        return _navigateToNormal(const FortuneHandView(), isFullScreenDialog: true);
      case AppRoutes.fortuneDream:
        return _navigateToNormal(const FortuneDreamView(), isFullScreenDialog: true);
      case AppRoutes.biorhythm:
        return _navigateToNormal(const BiorhythmView(), isFullScreenDialog: true);
      case AppRoutes.astrology:
        return _navigateToNormal(const AstrologyView(), isFullScreenDialog: true);
      case AppRoutes.numerology:
        return _navigateToNormal(const NumerologyView(), isFullScreenDialog: true);
      case AppRoutes.numerologyDetail:
        final args = routeSettings.arguments as Map<String, dynamic>;
        final selectedItem = args['selectedItem'] as NumerologyItem;
        final values = args['values'] as Map<NumerologyItem, int>;
        return _navigateToNormal(
            NumerologyDetailView(
              selectedItem: selectedItem,
              values: values,
            ),
            isFullScreenDialog: false);
      default:
        return null;
    }
  }

  Route<dynamic>? _navigateToNormal(Widget child, {bool? isFullScreenDialog}) {
    return MaterialPageRoute(
      builder: (context) {
        return child;
      },
      fullscreenDialog: isFullScreenDialog ?? false,
    );
  }
}

enum AppRoutes {
  splash,
  login,
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
  arView,
}

extension AppRoutesExtension on AppRoutes {
  String get path => '/$name';
}
