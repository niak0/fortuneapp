import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/auth/auth_notifier.dart';
import 'package:fortuneapp/enums/drawer_items.dart';

import '../../core/navigation/app_navigator.dart';

// Uygulamanın yan çekmecesi (drawer).
class SideBar extends ConsumerWidget {
  const SideBar({super.key});

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Çıkış yap"),
          content: const Text("Çıkış yapmak istediğinize emin misiniz?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await ref.read(authProvider.notifier).signOut();
                ref.read(appNavigatorProvider).pushAndRemoveUntil(AppRoutes.login);
              },
              child: const Text("Çıkış Yap"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Bu işlem geri alınamaz"),
          content: const Text("Hesabınızı silmek istediğinize emin misiniz?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // await context.read<AuthManager>().deleteUser();
                // ref.read(appNavigatorProvider).pushAndRemoveUntil(AppRoutes.login);
              },
              child: const Text("Hesabı Sil", style: TextStyle(color: Colors.red, fontSize: 14)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width / 1.6,
        child: ListView(padding: const EdgeInsets.symmetric(vertical: 10), children: [
          DrawerItems.profile.customListTile(onTap: () {
            ref.read(appNavigatorProvider).pushToPage(AppRoutes.profileEdit);
          }),
          DrawerItems.addGold.customListTile(onTap: () {
            ref.read(appNavigatorProvider).pushToPage(AppRoutes.buyCredits);
          }),
          const Divider(),
          DrawerItems.feedback.customListTile(onTap: () {
            ref.read(appNavigatorProvider).pushToPage(AppRoutes.settings);
          }),
          DrawerItems.contactUs.customListTile(onTap: () {}),
          const Divider(),
          DrawerItems.termsOfService.customListTile(onTap: () {}),
          DrawerItems.privacyPolicy.customListTile(onTap: () {}),
          // DrawerItems.settings.customListTile(onTap: () {
          //   ref.read(appNavigatorProvider).pushToPage(AppRoutes.settings);
          // }),
          // Container(
          //   height: 200,
          //   color: Theme.of(context).colorScheme.primaryContainer,
          //   child: googleAds.showBannerAd(),
          // )
          const Divider(),
          SizedBox(height: 30),
          Card(
              child: ElevatedButton(
                  onPressed: () {
                    if (context.mounted) {
                      _showSignOutDialog(context, ref);
                    }
                  },
                  child: const Text('Çıkış Yap'))),

          TextButton(
              onPressed: () {
                if (context.mounted) {
                  _showDeleteAccountDialog(context);
                }
              },
              child: const Text("Hesabımı Sil", style: TextStyle(color: Colors.red, fontSize: 16))),
        ]),
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
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: onTap,
    );
  }
}
