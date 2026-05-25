import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/logic/gold_controller.dart';

import '../../../core/navigation/app_navigator.dart';
import '../../../core/navigation/app_navigator_manager.dart';
import '../home_view_model.dart';
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

  @override
  Widget build(BuildContext context) {
    final asyncFortunes = ref.watch(homeViewModelProvider);
    final vm = ref.read(homeViewModelProvider.notifier);
    final goldController = ref.read(goldControllerProvider);

    return asyncFortunes.maybeWhen(
      data: (fortunes) {
        if (fortunes.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 80,
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: fortunes.length,
                  itemBuilder: (context, index) {
                    final fortune = fortunes[index];
                    final isAccessible = fortune.isAccessible ?? false;
                    final isRead = fortune.isRead ?? false;
                    final unlockTime = fortune.unlockTime ?? DateTime.now();

                    return Center(
                      child: ListTile(
                        tileColor: Theme.of(context).colorScheme.primary,
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5),
                        title: Text(
                          isAccessible ? 'Falın hazır' : 'Yorumlanıyor',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          isAccessible
                              ? 'Hemen Oku!'
                              : 'Yaklaşık ${vm.calculateRemainingTimes(unlockTime).inMinutes + 1} dk.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        leading: Icon(
                          Icons.coffee,
                          size: 50,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        trailing: isAccessible
                            ? null
                            : ElevatedButton(
                                onPressed: () async {
                                  await vm.makeFortuneAccessible(
                                      fortune.id ?? '');
                                  await goldController.decreaseGold();
                                },
                                child: const Text('Hızlandır'),
                              ),
                        onTap: isAccessible
                            ? () async {
                                if (!isRead) {
                                  await vm.markAsRead(fortune.id ?? '');
                                }
                                AppNavigatorManager.instance.pushToPage(
                                  AppRoutes.readFortune,
                                  arguments: {'currentContent': fortune},
                                );
                              }
                            : null,
                      ),
                    );
                  },
                ),
              ),
              if (fortunes.length > 1)
                SizedBox(
                  height: 20,
                  child: Center(
                    child: DotsIndicator(
                      controller: _pageController,
                      itemCount: fortunes.length,
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
