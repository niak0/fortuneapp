import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/utilities/connectivity_service.dart';
import 'package:fortuneapp/core/utilities/theme.dart';

import 'core/navigation/app_navigator.dart';
import 'core/navigation/app_router.dart';
import 'core/utilities/util.dart';
import 'core/widgets/no_internet_dialog.dart';
import 'firebase_options.dart';

// Uygulamanın giriş noktası — Firebase init + Riverpod ProviderScope.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

// MaterialApp kökü; tema, go_router ve bağlantı katmanını kurar.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // appNavigator'ı ilk burada okuyarak AppNavigatorManager.bind(...) tetiklenir.
    ref.watch(appNavigatorProvider);
    final router = ref.watch(goRouterProvider);
    final textTheme = createTextTheme(context, 'Roboto', 'Roboto');
    final theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      theme: theme.dark(),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      builder: (context, child) {
        final connectivity = ref.watch(connectivityServiceProvider);
        return connectivity.maybeWhen(
          data: (connected) => connected
              ? (child ?? const SizedBox.shrink())
              : const NoInternetDialog(),
          orElse: () => child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
