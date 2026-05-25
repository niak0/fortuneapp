import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/current_user.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/navigation/app_navigator_manager.dart';
import '../sider_bar/sider_bar.dart';
import 'navigation_bar_manager.dart';

// Anasayfa + Fallarım sekmeleri arasında geçiş yapılan ana kabuk.
class ProjectNavigationBar extends ConsumerStatefulWidget {
  const ProjectNavigationBar({super.key});

  @override
  ConsumerState<ProjectNavigationBar> createState() =>
      _ProjectNavigationBarState();
}

class _ProjectNavigationBarState extends ConsumerState<ProjectNavigationBar> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationBarViewModelProvider);
    final userCoin = ref.watch(
      currentUserProvider.select((value) => value.value?.coin ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(navBarItems[currentIndex].label ?? 'null'),
        actions: [
          TextButton.icon(
            onPressed: () =>
                AppNavigatorManager.instance.pushToPage(AppRoutes.buyCredits),
            icon: const Icon(Icons.monetization_on_outlined),
            label: Text(userCoin.toString()),
          ),
        ],
      ),
      drawer: const SideBar(),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) =>
                  ref.read(navigationBarViewModelProvider.notifier).setIndex(index),
              children: navBarPages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
          ref.read(navigationBarViewModelProvider.notifier).setIndex(index);
        },
        items: navBarItems,
      ),
    );
  }
}
