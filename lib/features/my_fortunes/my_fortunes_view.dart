import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';

import '../../core/navigation/app_navigator.dart';
import '../../core/widgets/loading_dialog.dart';
import 'my_fortunes_providers.dart';

// Kullanıcının fal geçmişini listeleyen ekran.
class MyFortunesView extends ConsumerWidget {
  const MyFortunesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFortunes = ref.watch(myFortunesViewModelProvider);
    final notifier = ref.read(myFortunesViewModelProvider.notifier);

    return Scaffold(
      body: asyncFortunes.when(
        loading: () => const Center(child: LoadingDialog()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (fortunes) {
          if (fortunes.isEmpty) {
            return const Center(
              child: Text(
                'Henüz oluşturulmuş bir fal yok.',
                style: TextStyle(fontSize: 16.0),
              ),
            );
          }

          return ListView.builder(
            key: ValueKey(fortunes.length),
            itemCount: fortunes.length,
            itemBuilder: (context, index) {
              final fortune = fortunes[index];
              final isRead = fortune.isRead ?? false;
              final isAccessible = fortune.isAccessible ?? false;
              final type = fortune.fortuneType ?? 'unknown';

              return Card(
                color: isRead
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
                child: ListTile(
                  leading: Icon(_iconForType(type)),
                  trailing: isAccessible
                      ? const Icon(Icons.chevron_right_outlined)
                      : const Icon(Icons.timelapse_outlined),
                  title: Row(
                    children: [
                      Text('${fortune.fortuneType} '),
                      if (fortune.fortuneTopic != null)
                        Chip(
                          padding: EdgeInsets.zero,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceBright,
                          label: Text(
                            fortune.fortuneTopic!,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                    ],
                  ),
                  subtitle: Text(
                    isAccessible
                        ? fortune.formattedDate
                        : '${fortune.formattedDate} Yorumlanıyor...',
                  ),
                  onTap: isAccessible
                      ? () async {
                          if (!isRead) {
                            await notifier.markAsRead(fortune.id!);
                          }
                          ref.read(appNavigatorProvider).pushToPage(
                            AppRoutes.readFortune,
                            arguments: {'currentContent': fortune},
                          );
                        }
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'coffee':
        return ContentType.coffee.icon;
      case 'hand':
        return ContentType.hand.icon;
      case 'tarot':
        return ContentType.tarot.icon;
      case 'dream':
        return ContentType.dream.icon;
      case 'astrology':
        return Icons.stars;
      default:
        return Icons.help;
    }
  }
}
