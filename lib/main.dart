import 'package:flutter/material.dart';
import 'package:fortuneapp/core/network/mock_firebase_service.dart';
import 'package:fortuneapp/core/utilitys/theme.dart';
import 'package:fortuneapp/core/navigation/app_navigator.dart';
import 'package:fortuneapp/core/logic/gold_controller.dart';
import 'package:fortuneapp/core/models/current_user.dart';
import 'package:fortuneapp/core/utils/connectivity_service.dart';
import 'package:fortuneapp/core/utils/gold_manager.dart';
import 'package:provider/provider.dart';
import 'core/auth/auth_manager.dart';
import 'core/navigation/app_navigator_manager.dart';
import 'core/network/gpt_service.dart';
import 'core/utilitys/util.dart';
import 'core/widgets/no_internet_dialog.dart';
import 'core/utils/app_initializer.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        /// Providers of App Services
        Provider(create: (_) => MockFirebaseService()),
        Provider(create: (_) => GptService()),
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => CurrentUser()),
        Provider(create: (_) => AuthManager()),
        Provider(
            create: (context) => GoldManager(
                  firebaseService: context.read<MockFirebaseService>(),
                  currentUser: context.read<CurrentUser>(),
                )),
        Provider(
            create: (context) => GoldController(
                  context.read<GoldManager>(),
                )),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget with AppNavigator {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppInitializer.init(context);

    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      theme: theme.dark(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: onGenerateRoute,
      navigatorKey: AppNavigatorManager.instance.navigatorGlobalKey,
      builder: (context, child) {
        return Consumer<ConnectivityService>(
          builder: (context, connectivityService, child) {
            if (!connectivityService.isConnected) {
              return const NoInternetDialog();
            }
            return child!;
          },
          child: child,
        );
      },
    );
  }
}
