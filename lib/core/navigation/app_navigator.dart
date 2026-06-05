import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

// go_router üzerinden çalışan AppNavigator implementasyonu.
class GoRouterAppNavigator implements AppNavigator {
  GoRouterAppNavigator(this._ref);
  final Ref _ref;

  GoRouter get _router => _ref.read(goRouterProvider);

  @override
  GlobalKey<NavigatorState> get key =>
      _router.routerDelegate.navigatorKey;

  @override
  BuildContext? get currentContext => key.currentContext;

  @override
  Future<dynamic>? pushToPage(AppRoutes route, {Object? arguments}) {
    _router.push<dynamic>(route.path, extra: arguments);
    return null;
  }

  @override
  Future<dynamic>? pushAndRemoveUntil(AppRoutes route, {Object? arguments}) {
    _router.go(route.path, extra: arguments);
    return null;
  }

  @override
  void pop([Object? result]) {
    if (_router.canPop()) _router.pop(result);
  }
}

// AppNavigator DI provider'ı — go_router instance'ını sarar.
@Riverpod(keepAlive: true)
AppNavigator appNavigator(Ref ref) {
  final nav = GoRouterAppNavigator(ref);
  // Legacy facade'ın aynı key'i göstermesi için forward et.
  AppNavigatorManager.bind(nav);
  return nav;
}
