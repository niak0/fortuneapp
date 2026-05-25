import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/widgets/loading_dialog.dart';

import '../../core/auth/current_user.dart';
import '../../core/navigation/app_navigator.dart';

// Açılış ekranı — CurrentUser hazır olunca anasayfaya yönlendirir.
class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(currentUserProvider, (previous, next) {
      if (_navigated) return;
      if (next is AsyncData) {
        _navigated = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(appNavigatorProvider).pushAndRemoveUntil(AppRoutes.home);
        });
      }
    });

    return const Scaffold(body: Center(child: LoadingDialog()));
  }
}
