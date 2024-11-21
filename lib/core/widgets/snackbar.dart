import 'package:flutter/material.dart';

import '../navigation/app_navigator_manager.dart';

class CustomSnackBar {
  static void show(String message) {
    final currentContext = AppNavigatorManager.instance.navigatorGlobalKey.currentContext;
    if (currentContext != null) {
      final snackBar = SnackBar(
        content: Text(
          message,
          style: Theme.of(currentContext).textTheme.bodyMedium,
        ),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        backgroundColor: Theme.of(currentContext).colorScheme.primary,
        closeIconColor: Theme.of(currentContext).colorScheme.onPrimary,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );
      ScaffoldMessenger.of(currentContext).showSnackBar(snackBar);
    }
  }
}
