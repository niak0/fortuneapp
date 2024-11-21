import 'package:flutter/material.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';

class FortuneTopicCard extends StatelessWidget {
  const FortuneTopicCard({super.key,
    required this.selectedFortuneTopic,
    required this.fortuneTopicOption,
  });

  final FortuneTopic? selectedFortuneTopic;
  final FortuneTopic fortuneTopicOption;

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).colorScheme;
    return Container(
        decoration: BoxDecoration(
          color: selectedFortuneTopic == fortuneTopicOption ? color.primary : color.onPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              fortuneTopicOption.icon,
              size: 50,
              color: color.onSurface,
        ),
            Text(
              fortuneTopicOption.displayName,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ));
  }
}