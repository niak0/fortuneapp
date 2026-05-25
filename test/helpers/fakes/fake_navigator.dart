import 'package:flutter/widgets.dart';
import 'package:fortuneapp/core/navigation/app_navigator.dart';

// Navigasyon çağrılarını yakalayan fake.
class FakeNavigator implements AppNavigator {
  final List<(String, AppRoutes, Object?)> calls = [];

  @override
  GlobalKey<NavigatorState> get key => GlobalKey<NavigatorState>();

  @override
  BuildContext? get currentContext => null;

  @override
  Future<dynamic>? pushToPage(AppRoutes route, {Object? arguments}) {
    calls.add(('pushToPage', route, arguments));
    return null;
  }

  @override
  Future<dynamic>? pushAndRemoveUntil(AppRoutes route, {Object? arguments}) {
    calls.add(('pushAndRemoveUntil', route, arguments));
    return null;
  }

  @override
  void pop([Object? result]) {
    calls.add(('pop', AppRoutes.splash, result));
  }
}
