import 'package:flutter/material.dart';

import '../../../core/theme/mystic_dimens.dart';
import '../../../core/theme/mystic_tokens.dart';
import '../model/home_items.dart';

// Bir fal kategorisini mistik kart olarak sunar (altın çerçeve + gradyan veil).
class FortuneCard extends StatelessWidget {
  const FortuneCard({
    super.key,
    required this.item,
    required this.onTap,
    this.featured = false,
  });

  final HomeItemModel item;
  final VoidCallback onTap;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Material(
      color: scheme.surfaceContainer,
      borderRadius: MysticRadius.mdAll,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Kategori görseli.
            Image.asset(item.icon, fit: BoxFit.cover),
            // Üstten altın halo + alttan koyu örtü (başlık okunurluğu).
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 0.9,
                  colors: [tokens.halo, Colors.transparent],
                  stops: const [0, 0.5],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    scheme.scrim.withValues(alpha: 0.55),
                    scheme.scrim.withValues(alpha: 0.85),
                  ],
                  stops: const [0.3, 0.78, 1],
                ),
              ),
            ),
            // İnce altın iç çerçeve.
            Padding(
              padding: const EdgeInsets.all(7),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MysticRadius.md - 7),
                  border: Border.all(color: tokens.line),
                ),
              ),
            ),
            // Köşe etiketi.
            if (item.tag != null)
              Positioned(top: 12, left: 12, child: _Tag(label: item.tag!)),
            // Alt içerik: başlık + alt başlık + maliyet.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.titleLarge?.copyWith(
                              fontSize: featured ? 25 : 19,
                              color: scheme.onSurface,
                              shadows: [
                                Shadow(
                                  color: scheme.scrim.withValues(alpha: 0.55),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            item.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.titleMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: tokens.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _CostBadge(cost: item.cost),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Kartın köşesindeki altın etiket çipi.
class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tokens.gold,
        borderRadius: BorderRadius.circular(MysticRadius.pill),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: scheme.onPrimary,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// Altın maliyet rozeti (0 → "Ücretsiz").
class _CostBadge extends StatelessWidget {
  const _CostBadge({required this.cost});

  final int cost;

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final isFree = cost == 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isFree ? 10 : 9, vertical: 5),
      decoration: BoxDecoration(
        color: scheme.scrim.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(MysticRadius.pill),
        border: Border.all(color: tokens.lineStrong),
      ),
      child: isFree
          ? Text(
              'Ücretsiz',
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.monetization_on_outlined,
                  size: 13,
                  color: tokens.goldBright,
                ),
                const SizedBox(width: 4),
                Text(
                  '$cost',
                  style: TextStyle(
                    color: tokens.goldBright,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}
