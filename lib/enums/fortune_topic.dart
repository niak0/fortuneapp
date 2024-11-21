
import 'package:flutter/material.dart';

enum FortuneTopic {
  general("Genel", Icons.star_border_outlined),
  love("Aşk", Icons.heart_broken_outlined),
  health("Sağlık", Icons.ac_unit_outlined),
  career("Kariyer", Icons.monetization_on_outlined);

  final String displayName;
  final IconData icon;
  const FortuneTopic(this.displayName, this.icon);

}

