import 'package:flutter/material.dart';

import 'app_navigator.dart';

class AppNavigatorManager {
  AppNavigatorManager._();
  static AppNavigatorManager instance = AppNavigatorManager._();
  final GlobalKey<NavigatorState> _navigatorGlobalKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorGlobalKey => _navigatorGlobalKey;

  Future<dynamic>? pushToPage(AppRoutes route, {Object? arguments}) {
    return _navigatorGlobalKey.currentState?.pushNamed(route.path, arguments: arguments);
    //pushToPage rota isteğini oluşturur, onGenerateRoute o isteği alır ve ilgili sayfayı döndürerek sayfayı açar.
  }

  Future<dynamic>? pushAndRemoveUntil(AppRoutes newRoute, {Object? arguments}) {
    return _navigatorGlobalKey.currentState?.pushNamedAndRemoveUntil(newRoute.path, (Route<dynamic> route) => false, arguments: arguments,
    );
  }


  void pop([Object? result]) {
    _navigatorGlobalKey.currentState?.pop(result);
  }
}
