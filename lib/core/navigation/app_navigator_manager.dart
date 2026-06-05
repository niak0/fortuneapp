import 'package:flutter/material.dart';

import 'app_navigator.dart';
import 'app_router.dart';

// DEPRECATED: Yeni kodda `appNavigatorProvider` kullanın.
// Bu facade sadece `CustomSnackBar` / `LoadingDialog` gibi context-suz statik
// helper'lar için tutuluyor. Provider initialize edilince `bind()` çağrılır
// ve aynı `GoRouter` navigator key'ini paylaşır.
class AppNavigatorManager implements AppNavigator {
  AppNavigatorManager._();

  static final AppNavigatorManager instance = AppNavigatorManager._();

  AppNavigator? _delegate;

  // appNavigatorProvider tarafından çağrılır — gerçek implementasyonu bağlar.
  static void bind(AppNavigator nav) {
    instance._delegate = nav;
  }

  // Eski kod yolu için fallback key (delegate bağlanmadan erişilirse).
  static final GlobalKey<NavigatorState> _fallbackKey =
      GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get key => _delegate?.key ?? _fallbackKey;

  GlobalKey<NavigatorState> get navigatorGlobalKey => key;

  @override
  BuildContext? get currentContext => _delegate?.currentContext;

  @override
  Future<dynamic>? pushToPage(AppRoutes route, {Object? arguments}) =>
      _delegate?.pushToPage(route, arguments: arguments);

  @override
  Future<dynamic>? pushAndRemoveUntil(AppRoutes route, {Object? arguments}) =>
      _delegate?.pushAndRemoveUntil(route, arguments: arguments);

  @override
  void pop([Object? result]) => _delegate?.pop(result);
}
