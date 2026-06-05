import 'package:flutter/widgets.dart';

/// Tasarım sistemi ölçüleri (köşe yarıçapı + boşluk). `tokens.css` `--r-*` /
/// `--s-*` karşılığı. Sabit değerlerin tek kaynağıdır; view'larda elle yarıçap
/// yazılmaz.
abstract final class MysticRadius {
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 26;
  static const double pill = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
}

/// 4 tabanlı boşluk ölçeği.
abstract final class MysticSpace {
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x5 = 24;
  static const double x6 = 32;
}
