import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/navigation/app_navigator_manager.dart';
import '../sider_bar/sider_bar.dart';
import '../../core/models/current_user.dart';
import 'navigation_bar_manager.dart';

class ProjectNavigationBar extends StatefulWidget {
  const ProjectNavigationBar({super.key});

  @override
  State<ProjectNavigationBar> createState() => _ProjectNavigationBarState();
}

class _ProjectNavigationBarState extends State<ProjectNavigationBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userCoin = context.watch<CurrentUser>().currentUser?.coin ?? 0;

    PageController pageController = PageController();

    return ChangeNotifierProvider(
        create: (_) => NavigationBarViewModel(),
        child: Consumer<NavigationBarViewModel>(builder: (context, bottomNavManager, _) {
          return Scaffold(
            appBar: AppBar(title: Text(bottomNavManager.getAppBarTitle()), actions: [
              TextButton.icon(
                  onPressed: () {
                    AppNavigatorManager.instance.pushToPage(AppRoutes.buyCredits);
                  },
                  icon: const Icon(Icons.monetization_on_outlined),
                  label: Text(userCoin.toString())),
            ]),
            drawer: const SideBar(),
            body: Column(
              children: [
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    onPageChanged: (index) {
                      bottomNavManager.setIndex(index);
                    },
                    children: bottomNavManager.pages,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: bottomNavManager.currentIndex,
              onTap: (index) {
                pageController.jumpToPage(index); //sayfa geçişi
                bottomNavManager.setIndex(index); //geçiş yapıldığı sayfa indexi ve title güncelle
              },
              items: bottomNavManager.navBarItems,
            ),
          );
        }));
  }
}
