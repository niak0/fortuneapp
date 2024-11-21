import 'package:flutter/material.dart';

enum ZodiacElements {
  health,
  love,
  money;

  Color get color {
    switch (this) {
      case health:
        return Colors.blue;
      case love:
        return Colors.red;
      case money:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  String get displayName {
    switch (this) {
      case ZodiacElements.health:
        return "Sağlık";
      case ZodiacElements.love:
        return "Aşk";
      case ZodiacElements.money:
        return "Para";
      default:
        return "";
    }
  }
  IconData get icon {
    switch (this) {
      case ZodiacElements.health:
        return Icons.health_and_safety_outlined;
      case ZodiacElements.love:
        return Icons.favorite_outlined;
      case ZodiacElements.money:
        return Icons.attach_money_outlined;
      default:
        return Icons.shopping_bag_outlined;
    }
  }
}