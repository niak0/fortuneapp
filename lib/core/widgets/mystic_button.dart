import 'package:flutter/material.dart';

import '../theme/mystic_dimens.dart';
import '../theme/mystic_tokens.dart';

// Altın gradient, glow'lu, tam genişlik birincil aksiyon butonu (CTA).
// Opsiyonel leading ikon + opsiyonel altın maliyet rozeti taşır.
class MysticButton extends StatelessWidget {
  const MysticButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.cost,
    this.enabled = true,
  });

  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final int? cost;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MysticRadius.pill),
          gradient: enabled
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [tokens.goldBright, tokens.gold],
                )
              : null,
          color: enabled ? null : scheme.surfaceContainerHigh,
          border: enabled ? null : Border.all(color: tokens.line),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: tokens.halo,
                    blurRadius: 20,
                    spreadRadius: -6,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(MysticRadius.pill),
            onTap: enabled ? onPressed : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: MysticSpace.x5,
                vertical: MysticSpace.x4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 18,
                      color: enabled ? scheme.onPrimary : tokens.inkFaint,
                    ),
                    const SizedBox(width: MysticSpace.x2),
                  ],
                  Text(
                    this.text,
                    style: text.labelLarge?.copyWith(
                      color: enabled ? scheme.onPrimary : tokens.inkFaint,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (cost != null) ...[
                    const SizedBox(width: MysticSpace.x2),
                    _CostBadge(cost: cost!, enabled: enabled),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Buton içinde "· N ✦" biçiminde altın maliyet rozeti.
class _CostBadge extends StatelessWidget {
  const _CostBadge({required this.cost, required this.enabled});

  final int cost;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final color = enabled ? scheme.onPrimary : tokens.inkFaint;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MysticRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$cost',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: color),
          ),
          const SizedBox(width: 3),
          Icon(Icons.auto_awesome, size: 11, color: color),
        ],
      ),
    );
  }
}
