import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/theme/theme_providers.dart';
import 'package:fortuneapp/core/utilities/connectivity_service.dart';

import 'core/data/ad_service.dart';
import 'core/data/fortune_refund_watcher.dart';
import 'core/navigation/app_navigator.dart';
import 'core/navigation/app_router.dart';
import 'core/widgets/no_internet_dialog.dart';
import 'firebase_options.dart';

// Uygulamanın giriş noktası — Firebase init + Riverpod ProviderScope.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final container = ProviderContainer();
  // AdMob SDK'sını uygulama açılışında başlat ve reklamları önceden yükle.
  unawaited(container.read(adServiceProvider).init());
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

// MaterialApp kökü; tema, go_router ve bağlantı katmanını kurar.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // appNavigator'ı ilk burada okuyarak AppNavigatorManager.bind(...) tetiklenir.
    ref.watch(appNavigatorProvider);
    // Başarısız fal üretimlerinde altını iade eden arka plan izleyiciyi canlı tut.
    ref.watch(fortuneRefundWatcherProvider);
    final router = ref.watch(goRouterProvider);
    final theme = ref.watch(appThemeDataProvider);

    return MaterialApp.router(
      theme: theme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      builder: (context, child) {
        final connectivity = ref.watch(connectivityServiceProvider);
        return connectivity.maybeWhen(
          data: (connected) => connected ? (child ?? const SizedBox.shrink()) : const NoInternetDialog(),
          orElse: () => child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
