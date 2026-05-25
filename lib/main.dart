import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/utilitys/theme.dart';
import 'package:fortuneapp/core/utils/connectivity_service.dart';

import 'core/navigation/app_navigator.dart';
import 'core/navigation/app_navigator_manager.dart';
import 'core/utilitys/util.dart';
import 'core/widgets/no_internet_dialog.dart';
import 'firebase_options.dart';

// Uygulamanın giriş noktası — Firebase init + Riverpod ProviderScope.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

// MaterialApp kökü; tema, route ve bağlantı katmanını kurar.
class MyApp extends ConsumerWidget with AppNavigator {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = createTextTheme(context, 'Roboto', 'Roboto');
    final theme = MaterialTheme(textTheme);
    final connectivity = ref.watch(connectivityServiceProvider);

    return MaterialApp(
      theme: theme.dark(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: onGenerateRoute,
      navigatorKey: AppNavigatorManager.instance.navigatorGlobalKey,
      builder: (context, child) {
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
