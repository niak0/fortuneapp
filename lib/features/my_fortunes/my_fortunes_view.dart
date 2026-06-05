import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/fortune_model.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/theme/mystic_tokens.dart';
import '../../core/widgets/loading_dialog.dart';
import '../../enums/gpt_content_type.dart';
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
          if (fortunes.isEmpty) return const _EmptyState();

          return ListView.builder(
            key: ValueKey(fortunes.length),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: fortunes.length,
            itemBuilder: (context, index) {
              final fortune = fortunes[index];
              final isAccessible = fortune.isAccessible ?? false;
              return _FortuneTile(
                fortune: fortune,
                onTap: isAccessible
                    ? () async {
                        if (!(fortune.isRead ?? false)) {
                          await notifier.markAsRead(fortune.id!);
                        }
                        ref
                            .read(appNavigatorProvider)
                            .pushToPage(
                              AppRoutes.readFortune,
                              arguments: {'currentContent': fortune},
                            );
                      }
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}

// Tek bir fal kaydını mistik kart olarak gösterir.
class _FortuneTile extends StatelessWidget {
  const _FortuneTile({required this.fortune, required this.onTap});

  final FortuneModel fortune;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    final isRead = fortune.isRead ?? false;
    final isAccessible = fortune.isAccessible ?? false;

    return Card(
      child: ListTile(
        // Okunmamış fallar altın çizgi ile vurgulanır.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: isRead ? tokens.line : tokens.gold),
        ),
        leading: Icon(
          fortune.fortuneType?.icon ?? Icons.auto_awesome_outlined,
          color: tokens.gold,
        ),
        trailing: Icon(
          isAccessible
              ? Icons.chevron_right_outlined
              : Icons.timelapse_outlined,
          color: isAccessible ? tokens.gold : tokens.inkFaint,
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                fortune.fortuneType?.displayName ?? 'Fal',
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (fortune.fortuneTopic != null) ...[
              const SizedBox(width: 8),
              _TopicChip(label: fortune.fortuneTopic!.displayName),
            ],
          ],
        ),
        subtitle: Text(
          isAccessible
              ? fortune.formattedDate
              : '${fortune.formattedDate} • Yorumlanıyor...',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: onTap,
      ),
    );
  }
}

// Fal konusunu gösteren küçük rozet.
class _TopicChip extends StatelessWidget {
  const _TopicChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tokens.line),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

// Hiç fal yokken gösterilen boş durum.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome_outlined, size: 64, color: tokens.gold),
          const SizedBox(height: 16),
          Text(
            'Henüz bir falın yok',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'İlk falını oluşturmak için bir fal türü seç.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
