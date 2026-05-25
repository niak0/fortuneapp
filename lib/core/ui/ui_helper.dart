import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../navigation/app_navigator.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/snackbar.dart';

part 'ui_helper.g.dart';

// SnackBar / dialog gibi yan etkileri soyutlayan arayüz.
// Test'te FakeUiHelper ile çağrılar capture edilebilir.
abstract class UiHelper {
  void showSnackBar(String message);
  void showLoading();
  void hideLoading();
}

// Üretim implementasyonu — mevcut CustomSnackBar / LoadingDialog'u kullanır.
class MaterialUiHelper implements UiHelper {
  MaterialUiHelper(this._ref);
  final Ref _ref;

  @override
  void showSnackBar(String message) {
    CustomSnackBar.show(message);
  }

  @override
  void showLoading() {
    final context = _ref.read(appNavigatorProvider).currentContext;
    if (context != null) LoadingDialog.show(context);
  }

  @override
  void hideLoading() {
    final context = _ref.read(appNavigatorProvider).currentContext;
    if (context != null) LoadingDialog.hide(context);
  }
}

// UiHelper DI provider'ı.
@Riverpod(keepAlive: true)
UiHelper uiHelper(Ref ref) => MaterialUiHelper(ref);
