import 'package:flutter/material.dart';
import 'package:fortuneapp/enums/zodiac_elements.dart';
import 'package:fortuneapp/enums/zodiac_sign.dart';
import 'package:fortuneapp/features/astrology/zodiac/zodiac_model.dart';
import 'package:provider/provider.dart';

import 'zodiac_view_model.dart';

class ZodiacView extends StatelessWidget {
  const ZodiacView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ZodiacViewModel>(
      create: (context) => ZodiacViewModel()..fetchZodiacSigns(),
      child: Scaffold(
        body: Consumer<ZodiacViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ZodiacDropdown(viewModel: viewModel),
                  ZodiacInfos(viewModel: viewModel),
                  ZodiacScores(viewModel: viewModel),
                  const Divider(thickness: 0.5, color: Colors.grey),
                  ZodiacSegmented(viewModel: viewModel),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ZodiacDropdown extends StatelessWidget {
  final ZodiacViewModel viewModel;

  const ZodiacDropdown({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(viewModel.selectedZodiac?.dateRange ?? 'Veri yok'),
      leading: Text(
        ZodiacSign.values
                .firstWhere(
                  (z) => z.name == viewModel.selectedZodiac?.sign,
                  orElse: () => ZodiacSign.aries,
                )
                .symbol ??
            viewModel.selectedZodiac?.sign ??
            'Aries',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      trailing: DropdownButton<ZodiacModel>(
        value: viewModel.selectedZodiac,
        underline: const SizedBox(),
        items: List.generate(viewModel.zodiacModels.length, (index) {
          ZodiacModel item = viewModel.zodiacModels[index];
          return DropdownMenuItem(
            value: item,
            child: Text(
              ZodiacSign.values
                  .firstWhere(
                    (z) => z.name == item.sign,
                    orElse: () => ZodiacSign.aries,
                  )
                  .turkishName,
            ),
          );
        }),
        onChanged: (value) {
          if (value != null) {
            viewModel.setSelectedZodiac(value);
          }
        },
      ),
    );
  }
}

class ZodiacInfos extends StatelessWidget {
  final ZodiacViewModel viewModel;

  const ZodiacInfos({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Gezegeni: ${viewModel.selectedZodiac?.planet ?? 'Bilinmiyor'}"),
            Text("Elementi: ${viewModel.selectedZodiac?.element ?? 'Bilinmiyor'}"),
          ],
        ),
        const SizedBox(height: 5),
        Text("Mottosu: ${viewModel.selectedZodiac?.motto ?? 'Bilinmiyor'}"),
      ],
    );
  }
}

class ZodiacScores extends StatelessWidget {
  final ZodiacViewModel viewModel;

  const ZodiacScores({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(ZodiacElements.values.length, (index) {
        ZodiacElements element = ZodiacElements.values[index];
        int value = viewModel.selectedZodiac?.getValue(element) ?? 0;
        return ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(element.displayName),
          leading: Icon(
            element.icon,
            color: element.color,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value.toString()),
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  value: (value / 10),
                  color: element.color,
                  backgroundColor: Colors.grey[300],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ZodiacSegmented extends StatelessWidget {
  const ZodiacSegmented({super.key, required this.viewModel});

  final ZodiacViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: [
        SegmentedButton<ZodiacSegments>(
          showSelectedIcon: false,
          segments: ZodiacSegments.values.map((segment) {
            return ButtonSegment(
              value: segment,
              label: Text(segment.displayName, style: Theme.of(context).textTheme.labelSmall),
            );
          }).toList(),
          selected: <ZodiacSegments>{viewModel.selectedSegment ?? ZodiacSegments.week},
          onSelectionChanged: (value) {
            viewModel.setSelectedSegment(value.first);
          },
        ),
        Text(
          viewModel.selectedZodiac?.getComment(viewModel.selectedSegment ?? ZodiacSegments.week) ?? 'Veri yok',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ]),
    );
  }
}

enum ZodiacSegments {
  // yesterday,
  // day,
  week,
  month,
  year,
}

extension ZodiacSegmentsExtension on ZodiacSegments {
  String get displayName {
    switch (this) {
      // case ZodiacSegments.yesterday:
      //   return "Dün";
      // case ZodiacSegments.day:
      //   return "Bugün";
      case ZodiacSegments.week:
        return "Haftalık";
      case ZodiacSegments.month:
        return "Aylık";
      case ZodiacSegments.year:
        return "Yıllık";
    }
  }
}
