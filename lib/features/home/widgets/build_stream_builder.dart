import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/utilities/gold_manager.dart';

import '../../../core/navigation/app_navigator.dart';
import '../../../core/theme/mystic_dimens.dart';
import '../../../core/theme/mystic_tokens.dart';
import '../../../core/widgets/snackbar.dart';
import '../../settings/settings_providers.dart';
import '../home_providers.dart';
import 'dots_indicator.dart';

// Yakın zamandaki falları (okunmamış/erişilemez) yatay swipe ile sunar.
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

  // Falı hızlandırmak için altın harcar; bakiye ve onay ayarını kontrol eder.
  Future<void> _accelerate(String fortuneId) async {
    final goldController = ref.read(goldManagerProvider);
    if (!goldController.checkGoldAndProceed(1)) {
      CustomSnackBar.show('Yeterli altının yok');
      return;
    }
    // Kullanıcı ayardan istediyse harcamadan önce onay sor.
    final askFirst =
        ref.read(settingsViewModelProvider).value?.askBeforeUsingGold ?? true;
    if (askFirst && await _confirmGoldUsage() != true) return;

    await ref
        .read(homeViewModelProvider.notifier)
        .makeFortuneAccessible(fortuneId);
    await goldController.decreaseGold();
  }

  // 1 altın harcamadan önce gösterilen onay diyaloğu.
  Future<bool?> _confirmGoldUsage() {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Altın Kullan'),
        content: const Text(
          'Bu falı hızlandırmak için 1 altın harcanacak. Onaylıyor musun?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Onayla'),
          ),
        ],
      ),
    );
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
                    final isAccessible = fortune.isAccessible ?? false;
                    final isRead = fortune.isRead ?? false;
                    final unlockTime = fortune.unlockTime ?? DateTime.now();
                    final remainingMin =
                        vm.calculateRemainingTimes(unlockTime).inMinutes + 1;

                    return _ActiveFortuneTile(
                      isAccessible: isAccessible,
                      remainingMinutes: remainingMin,
                      icon: fortune.fortuneType?.icon ?? Icons.coffee_rounded,
                      onAccelerate: () => _accelerate(fortune.id ?? ''),
                      onOpen: isAccessible
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

// Aktif fal durumu kartı — dairesel ilerleme + durum + "Hızlandır" / aç.
class _ActiveFortuneTile extends StatelessWidget {
  const _ActiveFortuneTile({
    required this.isAccessible,
    required this.remainingMinutes,
    required this.icon,
    required this.onAccelerate,
    required this.onOpen,
  });

  final bool isAccessible;
  final int remainingMinutes;
  final IconData icon;
  final VoidCallback onAccelerate;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

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
                // Dairesel ilerleme + ortada fincan ikonu.
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
                          value: isAccessible ? 1 : null,
                          strokeWidth: 2.5,
                          color: tokens.flame,
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
                        isAccessible ? 'HAZIR' : 'YORUMLANIYOR',
                        style: text.labelSmall?.copyWith(
                          color: tokens.flame,
                          letterSpacing: 1.6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isAccessible ? 'Falın seni bekliyor' : 'Telve okunuyor',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleMedium?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        isAccessible
                            ? 'Dokun ve oku'
                            : 'Yaklaşık $remainingMinutes dk.',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(color: tokens.inkSoft),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                if (isAccessible)
                  Icon(Icons.arrow_forward_ios, size: 16, color: tokens.gold)
                else
                  ElevatedButton.icon(
                    onPressed: onAccelerate,
                    icon: const Icon(Icons.bolt, size: 16),
                    label: const Text('Hızlandır'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
