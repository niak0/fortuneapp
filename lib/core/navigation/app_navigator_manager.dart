import 'package:flutter/material.dart';

import 'app_navigator.dart';
import 'app_router.dart';

// DEPRECATED: Yeni kodda `appNavigatorProvider` kullanın.
// Bu facade sadece context-suz statik helper'lar (CustomSnackBar, LoadingDialog)
// için tutuluyor; UI helper migration'ı bitince silinecek.
class AppNavigatorManager implements AppNavigator {
  AppNavigatorManager._(this._delegate);

  final AppNavigator _delegate;

  static final AppNavigatorManager instance =
      AppNavigatorManager._(RoutingNavigator(_managerKey));

  static final GlobalKey<NavigatorState> _managerKey =
      GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get key => _delegate.key;

  GlobalKey<NavigatorState> get navigatorGlobalKey => _delegate.key;

  @override
  BuildContext? get currentContext => _delegate.currentContext;

  @override
  Future<dynamic>? pushToPage(AppRoutes route, {Object? arguments}) =>
      _delegate.pushToPage(route, arguments: arguments);

  @override
  Future<dynamic>? pushAndRemoveUntil(AppRoutes route, {Object? arguments}) =>
      _delegate.pushAndRemoveUntil(route, arguments: arguments);

  @override
  void pop([Object? result]) => _delegate.pop(result);
}
