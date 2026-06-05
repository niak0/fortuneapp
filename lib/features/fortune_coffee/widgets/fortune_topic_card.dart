import 'package:flutter/material.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';

import '../../../core/theme/mystic_dimens.dart';
import '../../../core/theme/mystic_tokens.dart';

// Fal konusu kartı: seçili = altın gradient + glow, değil = mistik hairline.
class FortuneTopicCard extends StatelessWidget {
  const FortuneTopicCard({
    super.key,
    required this.selectedFortuneTopic,
    required this.fortuneTopicOption,
  });

  final FortuneTopic? selectedFortuneTopic;
  final FortuneTopic fortuneTopicOption;

  // Konuya göre semantik ikon rengi (seçili değilken).
  Color _accent(MysticTokens tokens) {
    switch (fortuneTopicOption) {
      case FortuneTopic.love:
        return tokens.love;
      case FortuneTopic.health:
        return tokens.health;
      case FortuneTopic.career:
        return tokens.money;
      case FortuneTopic.general:
        return tokens.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isSelected = selectedFortuneTopic == fortuneTopicOption;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: MysticRadius.mdAll,
        gradient: isSelected
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [tokens.goldBright, tokens.gold],
              )
            : null,
        color: isSelected ? null : scheme.surfaceContainerLow,
        border: Border.all(
          color: isSelected ? Colors.transparent : tokens.line,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: tokens.halo,
                  blurRadius: 22,
                  spreadRadius: -8,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            fortuneTopicOption.icon,
            size: 34,
            color: isSelected ? scheme.onPrimary : _accent(tokens),
          ),
          const SizedBox(height: MysticSpace.x2),
          Text(
            fortuneTopicOption.displayName,
            style: text.labelLarge?.copyWith(
              color: isSelected ? scheme.onPrimary : tokens.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
