import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/widgets/snackbar.dart';
import 'package:fortuneapp/enums/drawer_items.dart';

import '../../core/navigation/app_navigator.dart';

// Uygulamanın yan çekmecesi (drawer).
class SideBar extends ConsumerWidget {
  const SideBar({super.key});

  // Drawer'ı kapatır; sonra rota açar (geçiş sırasında çekmece kapanmış olur).
  void _goTo(BuildContext context, WidgetRef ref, AppRoutes route) {
    Scaffold.of(context).closeDrawer();
    ref.read(appNavigatorProvider).pushToPage(route);
  }

  // Drawer'ı kapatır; henüz hazır olmayan özellikler için bilgi verir.
  void _comingSoon(BuildContext context) {
    Scaffold.of(context).closeDrawer();
    CustomSnackBar.show('Yakında');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width / 1.6,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: [
            DrawerItems.profile.customListTile(
              onTap: () => _goTo(context, ref, AppRoutes.profile),
            ),
            DrawerItems.addGold.customListTile(
              onTap: () => _goTo(context, ref, AppRoutes.buyCredits),
            ),
            DrawerItems.settings.customListTile(
              onTap: () => _goTo(context, ref, AppRoutes.settings),
            ),
            const Divider(),
            DrawerItems.feedback.customListTile(
              onTap: () => _comingSoon(context),
            ),
            DrawerItems.contactUs.customListTile(
              onTap: () => _comingSoon(context),
            ),
            const Divider(),
            DrawerItems.termsOfService.customListTile(
              onTap: () => _comingSoon(context),
            ),
            DrawerItems.privacyPolicy.customListTile(
              onTap: () => _comingSoon(context),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
  });
  final VoidCallback onTap;
  final String title;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      iconColor: Theme.of(context).colorScheme.primary,
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      onTap: onTap,
    );
  }
}
