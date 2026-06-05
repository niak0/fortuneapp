import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/auth/auth_notifier.dart';
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

  // Oturumu kapatır ve anasayfaya döner (bootstrap yeni anon oturum açar).
  Future<void> _signOut(WidgetRef ref) async {
    await ref.read(authProvider.notifier).signOut();
    ref.read(appNavigatorProvider).pushAndRemoveUntil(AppRoutes.home);
  }

  // İptal/Onay düğmeli ortak onay diyaloğu (yıkıcı eylemde kırmızı vurgu).
  Future<void> _confirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String confirmLabel,
    required Future<void> Function() onConfirm,
    bool isDestructive = false,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('İptal'),
          ),
          TextButton(
            style: isDestructive
                ? TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  )
                : null,
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await onConfirm();
            },
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
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
            const Divider(),
            const SizedBox(height: 30),
            Card(
              child: ElevatedButton(
                onPressed: () => _confirmDialog(
                  context,
                  title: 'Çıkış yap',
                  content: 'Çıkış yapmak istediğinize emin misiniz?',
                  confirmLabel: 'Çıkış Yap',
                  onConfirm: () => _signOut(ref),
                ),
                child: const Text('Çıkış Yap'),
              ),
            ),
            TextButton(
              onPressed: () => _confirmDialog(
                context,
                title: 'Bu işlem geri alınamaz',
                content: 'Hesabınızı silmek istediğinize emin misiniz?',
                confirmLabel: 'Hesabı Sil',
                isDestructive: true,
                onConfirm: () => _signOut(ref),
              ),
              child: Text(
                'Hesabımı Sil',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 16,
                ),
              ),
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
