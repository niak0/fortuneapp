import 'package:flutter/material.dart';
import 'package:fortuneapp/core/logic/gold_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/navigation/app_navigator.dart';
import '../../../core/navigation/app_navigator_manager.dart';
import '../../../core/models/fortune_model.dart';
import '../home_view_model.dart';
import 'dots_indicator.dart';

class BuildStreamBuilder extends StatelessWidget {
  const BuildStreamBuilder({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    return StreamBuilder<List<ContentModel>>(
      stream: viewModel.recentFortunesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        final fortunes = snapshot.data ?? [];
        if (fortunes.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 80,
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: PageView.builder(
                  controller: pageController,
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                        title: Text(
                          isAccessible ? "Falın hazır" : "Yorumlanıyor",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          isAccessible ? 'Hemen Oku!' : 'Yaklaşık ${viewModel.calculateRemainingTimes(unlockTime).inMinutes + 1} dk.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        leading: Icon(Icons.coffee, size: 50, color: Theme.of(context).colorScheme.onSurface),
                        trailing: isAccessible
                            ? null
                            : Consumer<GoldController>(
                                builder: (context, goldController, child) {
                                  return ElevatedButton(
                                    onPressed: () async {
                                      await viewModel.makeFortuneAccessible(fortune.id ?? '');
                                      await goldController.decreaseGold();
                                    },
                                    child: const Text("Hızlandır"),
                                  );
                                },
                              ),
                        onTap: isAccessible
                            ? () async {
                                if (!isRead) {
                                  await viewModel.markAsRead(fortune.id ?? '');
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
                      controller: pageController,
                      itemCount: fortunes.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
