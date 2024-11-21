import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fortuneapp/core/widgets/snackbar.dart';
import 'package:fortuneapp/features/biorhythm/enum/biorhythm_items.dart';
import 'package:fortuneapp/features/biorhythm/helpers/day_items.dart';
import 'package:fortuneapp/features/biorhythm/biorhythm_view_model.dart';
import 'package:fortuneapp/features/biorhythm/helpers/circle_painter.dart';
import 'package:provider/provider.dart';

import '../../core/models/current_user.dart';

class BiorhythmView extends StatelessWidget {
  const BiorhythmView({super.key});

  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = Provider.of<CurrentUser>(context);

    return ChangeNotifierProvider<BiorhythmViewModel>(
      create: (context) => BiorhythmViewModel(currentUser.currentUser!.birthDate),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Biyoritim"),
          actions: [
            IconButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("Biorhythm nedir?");
                  }
                  CustomSnackBar.show("insanların günlük yaşamlarının belirli periyotlara sahip ritmik döngülerden önemli ölçüde etkilendiğine dair bir fikirdir.");
                },
                icon: const Icon(Icons.question_mark_rounded))
          ],
        ),
        body: Consumer<BiorhythmViewModel>(
          builder: (context, viewModel, child) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      SegmentedButton<DayItems>(
                        segments: List.generate(DayItems.values.length, (index) {
                          var item = DayItems.values[index];
                          return ButtonSegment(value: item, label: Text(item.displayName));
                        }),
                        showSelectedIcon: false,
                        selected: {viewModel.selectedDay},
                        onSelectionChanged: (Set<DayItems> newSelection) => viewModel.setSelectDay(newSelection.first),
                      ),
                      Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            BiorhythmItems.values.length,
                            (index) {
                              var item = BiorhythmItems.values[index];
                              return buildBiorhythmIndicator(
                                context,
                                item.name,
                                item.color,
                                item.icon,
                                viewModel.decimal(item.cycle),
                                viewModel.percentage(item.cycle),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(BiorhythmItems.values.length, (index) {
                          var item = BiorhythmItems.values[index];
                          int percentage = viewModel.percentage(item.cycle);
                          return buildBiorhythmComment(
                              context: context,
                              name: item.name,
                              comment: item.getComment(percentage),
                              icon: item.icon,
                              color: item.color,
                              percentage: percentage);
                        }),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildBiorhythmComment({
    required BuildContext context,
    required String name,
    required String comment,
    required IconData icon,
    required Color color,
    required int percentage,
  }) {
    return Card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(icon, color: color),
                title: Text(name, style: Theme.of(context).textTheme.headlineSmall),
                trailing: Text("$percentage/100", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color))),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(comment, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ),
    ]));
  }

  Widget buildBiorhythmIndicator(BuildContext context, String label, Color color, IconData icon, double percent, int decimal) {
    Duration duration = const Duration(milliseconds: 250);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: percent),
              duration: duration, // Animasyon süresi
              builder: (context, animatedPercent, child) {
                return CustomPaint(
                  painter: CirclePainter(animatedPercent, color),
                  child: Center(
                    child: TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: decimal), // Value animasyonu için IntTween kullanıyoruz
                      duration: duration,
                      builder: (context, animatedValue, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon, size: 30.0, color: color),
                            Text(
                              "$animatedValue%", // Animasyonlu yüzdelik değer
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color),
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
