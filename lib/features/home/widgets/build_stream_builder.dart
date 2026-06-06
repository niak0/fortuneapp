import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/navigation/app_navigator.dart';
import '../../../core/theme/mystic_dimens.dart';
import '../../../core/theme/mystic_tokens.dart';
import '../home_providers.dart';
import 'dots_indicator.dart';

// Yakın zamandaki falları (hazırlanıyor/hazır) yatay swipe ile sunar.
class BuildStreamBuilder extends ConsumerStatefulWidget {
  const BuildStreamBuilder({super.key});

  @override
  ConsumerState<BuildStreamBuilder> createState() => _BuildStreamBuilderState();
}

class _BuildStreamBuilderState extends ConsumerState<BuildStreamBuilder> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncFortunes = ref.watch(homeViewModelProvider);
    final vm = ref.read(homeViewModelProvider.notifier);

    return asyncFortunes.maybeWhen(
      data: (fortunes) {
        if (fortunes.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: MysticSpace.x4),
          child: Column(
            children: [
              SizedBox(
                height: 92,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: fortunes.length,
                  itemBuilder: (context, index) {
                    final fortune = fortunes[index];
                    final isReady = fortune.isReady;
                    final isErrored = fortune.isErrored;
                    final isRead = fortune.isRead ?? false;

                    return _ActiveFortuneTile(
                      isReady: isReady,
                      isErrored: isErrored,
                      icon: fortune.fortuneType?.icon ?? Icons.coffee_rounded,
                      onOpen: isReady
                          ? () async {
                              if (!isRead) {
                                await vm.markAsRead(fortune.id ?? '');
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
                ),
              ),
              if (fortunes.length > 1)
                Padding(
                  padding: const EdgeInsets.only(top: MysticSpace.x2),
                  child: SizedBox(
                    height: 12,
                    child: Center(
                      child: DotsIndicator(
                        controller: _pageController,
                        itemCount: fortunes.length,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

// Aktif fal durumu kartı — hazırlanıyor / hazır / hata durumunu gösterir.
class _ActiveFortuneTile extends StatelessWidget {
  const _ActiveFortuneTile({
    required this.isReady,
    required this.isErrored,
    required this.icon,
    required this.onOpen,
  });

  final bool isReady;
  final bool isErrored;
  final IconData icon;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    // Duruma göre etiket/başlık/açıklama metinleri.
    final String label;
    final String title;
    final String hint;
    if (isErrored) {
      label = 'HATA';
      title = 'Fal alınamadı';
      hint = 'Altının iade edildi';
    } else if (isReady) {
      label = 'HAZIR';
      title = 'Falın seni bekliyor';
      hint = 'Dokun ve oku';
    } else {
      label = 'YORUMLANIYOR';
      title = 'Telve okunuyor';
      hint = 'Birazdan hazır olacak';
    }

    return Material(
      color: Colors.transparent,
      borderRadius: MysticRadius.lgAll,
      child: InkWell(
        borderRadius: MysticRadius.lgAll,
        onTap: onOpen,
        child: Ink(
          decoration: BoxDecoration(
            gradient: tokens.heroGradient,
            borderRadius: MysticRadius.lgAll,
            border: Border.all(color: tokens.lineStrong),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Dairesel ilerleme + ortada fal tipi ikonu.
                SizedBox(
                  width: 52,
                  height: 52,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 52,
                        height: 52,
                        child: CircularProgressIndicator(
                          value: isReady || isErrored ? 1 : null,
                          strokeWidth: 2.5,
                          color: isErrored ? scheme.error : tokens.flame,
                          backgroundColor: tokens.line,
                        ),
                      ),
                      Icon(icon, size: 22, color: tokens.goldBright),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: text.labelSmall?.copyWith(
                          color: isErrored ? scheme.error : tokens.flame,
                          letterSpacing: 1.6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleMedium?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        hint,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(color: tokens.inkSoft),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                if (isReady)
                  Icon(Icons.arrow_forward_ios, size: 16, color: tokens.gold),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
