import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/widgets/snackbar.dart';
import 'package:fortuneapp/features/biorhythm/biorhythm_providers.dart';
import 'package:fortuneapp/features/biorhythm/enum/biorhythm_items.dart';
import 'package:fortuneapp/features/biorhythm/helpers/circle_painter.dart';
import 'package:fortuneapp/features/biorhythm/helpers/day_items.dart';

import '../../core/auth/current_user.dart';
import '../../core/theme/mystic_tokens.dart';

// Kullanıcının biyoritim grafiği ve yorumlarını gösteren ekran.
class BiorhythmView extends ConsumerWidget {
  const BiorhythmView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    return currentUserAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Hata: $e'))),
      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text('Kullanıcı yok')));
        }
        final vmProvider = biorhythmViewModelProvider(
          birthDate: user.birthDate,
        );
        final selectedDay = ref.watch(vmProvider);
        final vm = ref.read(vmProvider.notifier);
        final tokens = MysticTokens.of(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Biyoritim'),
            actions: [
              IconButton(
                onPressed: () {
                  if (kDebugMode) print('Biorhythm nedir?');
                  CustomSnackBar.show(
                    'insanların günlük yaşamlarının belirli periyotlara sahip ritmik döngülerden önemli ölçüde etkilendiğine dair bir fikirdir.',
                  );
                },
                icon: const Icon(Icons.question_mark_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    SegmentedButton<DayItems>(
                      segments: DayItems.values
                          .map(
                            (item) => ButtonSegment(
                              value: item,
                              label: Text(item.displayName),
                            ),
                          )
                          .toList(),
                      showSelectedIcon: false,
                      selected: {selectedDay},
                      onSelectionChanged: (newSelection) =>
                          vm.setSelectDay(newSelection.first),
                    ),
                    Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: BiorhythmItems.values
                            .map(
                              (item) => buildBiorhythmIndicator(
                                context,
                                item.name,
                                item.color(tokens),
                                item.icon,
                                vm.decimal(item.cycle),
                                vm.percentage(item.cycle),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: BiorhythmItems.values.map((item) {
                        final percentage = vm.percentage(item.cycle);
                        return buildBiorhythmComment(
                          context: context,
                          name: item.name,
                          comment: item.getComment(percentage),
                          icon: item.icon,
                          color: item.color(tokens),
                          percentage: percentage,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Bir biyoritim ögesinin metinsel yorumunu kart olarak çizer.
  Widget buildBiorhythmComment({
    required BuildContext context,
    required String name,
    required String comment,
    required IconData icon,
    required Color color,
    required int percentage,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(icon, color: color),
            title: Text(name, style: Theme.of(context).textTheme.headlineSmall),
            trailing: Text(
              '$percentage/100',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: color),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              comment,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Daire içinde animasyonlu yüzde göstergesi çizer.
  Widget buildBiorhythmIndicator(
    BuildContext context,
    String label,
    Color color,
    IconData icon,
    double percent,
    int decimal,
  ) {
    const duration = Duration(milliseconds: 250);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: percent),
              duration: duration,
              builder: (context, animatedPercent, child) {
                return CustomPaint(
                  painter: CirclePainter(
                    animatedPercent,
                    color,
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: Center(
                    child: TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: decimal),
                      duration: duration,
                      builder: (context, animatedValue, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon, size: 30.0, color: color),
                            Text(
                              '$animatedValue%',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(color: color),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
