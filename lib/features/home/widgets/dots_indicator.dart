import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/mystic_tokens.dart';

class DotsIndicator extends AnimatedWidget {
  const DotsIndicator({
    super.key,
    required this.controller,
    required this.itemCount,
    this.onPageSelected,
  }) : super(listenable: controller);

  final PageController controller;
  final int itemCount;
  final ValueChanged<int>? onPageSelected;

  static const double _kDotSize = 7.0;
  static const double _kDotSpacing = 20.0;

  // Aktif nokta altın, pasif noktalar sönük çizgi rengi (seçilmişliğe göre lerp).
  Widget _buildDot(BuildContext context, int index) {
    final tokens = MysticTokens.of(context);
    final selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    final zoom = 1.0 + selectedness;
    final color = Color.lerp(tokens.lineStrong, tokens.gold, selectedness)!;
    return SizedBox(
      width: _kDotSpacing,
      child: Center(
        child: Material(
          color: color,
          type: MaterialType.circle,
          child: SizedBox(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: InkWell(onTap: () => onPageSelected?.call(index)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        itemCount,
        (index) => _buildDot(context, index),
      ),
    );
  }
}
