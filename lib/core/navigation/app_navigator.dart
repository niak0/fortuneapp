import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_navigator_manager.dart';
import 'app_router.dart';

export 'app_router.dart' show AppRoutes, AppRoutesExtension;

part 'app_navigator.g.dart';

// Navigasyonu soyutlayan arayüz — provider override ile test edilebilir.
abstract class AppNavigator {
  GlobalKey<NavigatorState> get key;
  BuildContext? get currentContext;
  Future<dynamic>? pushToPage(AppRoutes route, {Object? arguments});
  Future<dynamic>? pushAndRemoveUntil(AppRoutes route, {Object? arguments});
  void pop([Object? result]);
}

// Gerçek navigator key kullanan implementasyon.
class RoutingNavigator implements AppNavigator {
  RoutingNavigator(this._key);

  final GlobalKey<NavigatorState> _key;

  @override
  GlobalKey<NavigatorState> get key => _key;

  @override
  BuildContext? get currentContext => _key.currentContext;

  @override
  Future<dynamic>? pushToPage(AppRoutes route, {Object? arguments}) {
    return _key.currentState?.pushNamed(route.path, arguments: arguments);
  }

  @override
  Future<dynamic>? pushAndRemoveUntil(AppRoutes route, {Object? arguments}) {
    return _key.currentState?.pushNamedAndRemoveUntil(
      route.path,
      (route) => false,
      arguments: arguments,
    );
  }

  @override
  void pop([Object? result]) {
    _key.currentState?.pop(result);
  }
}

// AppNavigator DI provider'ı — AppNavigatorManager singleton'ını döner ki
// statik helper'lar (CustomSnackBar, LoadingDialog) ile aynı navigator key'i paylaşsın.
// Test'te `appNavigatorProvider.overrideWithValue(FakeNavigator())` ile mock'lanabilir.
@Riverpod(keepAlive: true)
AppNavigator appNavigator(Ref ref) => AppNavigatorManager.instance;
