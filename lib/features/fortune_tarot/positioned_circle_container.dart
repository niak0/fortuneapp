import 'dart:math';

import 'package:flutter/material.dart';

import '../../../generated/assets.dart';

class PositionedCircleContainer extends StatelessWidget {
  final int index;
  final int totalContainers;
  final double radius;
  final double angle;
  final Size screenSize;

  const PositionedCircleContainer({
    super.key,
    required this.index,
    required this.totalContainers,
    required this.radius,
    required this.angle,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    final double currentAngle = ((2 * pi * index / totalContainers) + angle) * 2;
    // Kartın genişlik ve yüksekliğini dinamik olarak ayarlıyoruz
    const double cardWidth = 100;
    const double cardHeight = 120;

    // Çarkın ortasını hesaplıyoruz
    final double centerX = screenSize.width / 2;
    final double centerY = screenSize.height / 2;

    // X ve Y koordinatlarını, kartın merkezlenmiş bir şekilde yerleşmesi için dinamik olarak hesaplıyoruz
    final double x = radius * cos(currentAngle) + centerX - (cardWidth / 2);
    final double y = radius * sin(currentAngle) + centerY - (cardHeight / 2);

    return Positioned(
      left: x,
      top: y,
      child: Transform.rotate(
        angle: currentAngle + pi / 2, // Kart döndürme
        child: Image.asset(
          Assets.iconIcTarotCard,
          width: cardWidth,
          height: cardHeight,
        ),
      ),
    );
  }
}
