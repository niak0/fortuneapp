import 'package:flutter/material.dart';

import '../../../core/theme/mystic_tokens.dart';

// Altın yıldız + tracked başlık + sönümlenen çizgiden oluşan bölüm başlığı.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    return Row(
      children: [
        Icon(Icons.auto_awesome, size: 14, color: tokens.gold),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: tokens.gold,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [tokens.lineStrong, Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
