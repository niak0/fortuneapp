import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/enums/zodiac_elements.dart';
import 'package:fortuneapp/enums/zodiac_sign.dart';
import 'package:fortuneapp/features/astrology/zodiac/zodiac_model.dart';

import 'zodiac_providers.dart';

// Burç ekranı — seçili burcun yorumlarını/skorlarını gösterir.
class ZodiacView extends ConsumerWidget {
  const ZodiacView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(zodiacViewModelProvider);
    return Scaffold(
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (state) {
          if (state.selectedZodiac == null) {
            return const Center(child: Text('Veri yok'));
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ZodiacDropdown(state: state),
                ZodiacInfos(state: state),
                ZodiacScores(state: state),
                const Divider(thickness: 0.5, color: Colors.grey),
                ZodiacSegmented(state: state),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Burç seçim dropdown'u.
class ZodiacDropdown extends ConsumerWidget {
  final ZodiacState state;

  const ZodiacDropdown({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(zodiacViewModelProvider.notifier);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(state.selectedZodiac?.dateRange ?? 'Veri yok'),
      leading: Text(
        ZodiacSign.values
                .firstWhere(
                  (z) => z.name == state.selectedZodiac?.sign,
                  orElse: () => ZodiacSign.aries,
                )
                .symbol ??
            state.selectedZodiac?.sign ??
            'Aries',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      trailing: DropdownButton<ZodiacModel>(
        value: state.selectedZodiac,
        underline: const SizedBox(),
        items: state.zodiacModels
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    ZodiacSign.values
                        .firstWhere(
                          (z) => z.name == item.sign,
                          orElse: () => ZodiacSign.aries,
                        )
                        .turkishName,
                  ),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) notifier.setSelectedZodiac(value);
        },
      ),
    );
  }
}

// Burcun temel bilgileri (gezegen, element, motto).
class ZodiacInfos extends StatelessWidget {
  final ZodiacState state;

  const ZodiacInfos({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final zodiac = state.selectedZodiac;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Gezegeni: ${zodiac?.planet ?? 'Bilinmiyor'}'),
            Text('Elementi: ${zodiac?.element ?? 'Bilinmiyor'}'),
          ],
        ),
        const SizedBox(height: 5),
        Text('Mottosu: ${zodiac?.motto ?? 'Bilinmiyor'}'),
      ],
    );
  }
}

// Burcun aşk/sağlık/para skorları.
class ZodiacScores extends StatelessWidget {
  final ZodiacState state;

  const ZodiacScores({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ZodiacElements.values.map((element) {
        final value = state.selectedZodiac?.getValue(element) ?? 0;
        return ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(element.displayName),
          leading: Icon(element.icon, color: element.color),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value.toString()),
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  value: value / 10,
                  color: element.color,
                  backgroundColor: Colors.grey[300],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// Haftalık/aylık/yıllık yorum seçici.
class ZodiacSegmented extends ConsumerWidget {
  const ZodiacSegmented({super.key, required this.state});

  final ZodiacState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(zodiacViewModelProvider.notifier);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SegmentedButton<ZodiacSegments>(
            showSelectedIcon: false,
            segments: ZodiacSegments.values
                .map((segment) => ButtonSegment(
                      value: segment,
                      label: Text(
                        segment.displayName,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ))
                .toList(),
            selected: {state.selectedSegment},
            onSelectionChanged: (value) =>
                notifier.setSelectedSegment(value.first),
          ),
          Text(
            state.selectedZodiac?.getComment(state.selectedSegment) ??
                'Veri yok',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

enum ZodiacSegments { week, month, year }

extension ZodiacSegmentsExtension on ZodiacSegments {
  String get displayName {
    switch (this) {
      case ZodiacSegments.week:
        return 'Haftalık';
      case ZodiacSegments.month:
        return 'Aylık';
      case ZodiacSegments.year:
        return 'Yıllık';
    }
  }
}
