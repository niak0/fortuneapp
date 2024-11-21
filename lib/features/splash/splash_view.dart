import 'package:flutter/material.dart';
import 'package:fortuneapp/core/widgets/loading_dialog.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/navigation/app_navigator_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    // TODO: Initialize the app
    await Future.delayed(const Duration(seconds: 2));
    AppNavigatorManager.instance.pushAndRemoveUntil(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingDialog(),
      ),
    );
  }
}
