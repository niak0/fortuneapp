import 'package:flutter/material.dart';

import '../features/sider_bar/sider_bar.dart';

enum DrawerItems { profile, addGold, contactUs, termsOfService, privacyPolicy, feedback, settings }

extension DrawerItemsExtension on DrawerItems {
  DrawerListTile customListTile({required VoidCallback onTap}) {
    switch (this) {
      case DrawerItems.profile:
        return DrawerListTile(
          title: "Profil",
          icon: const Icon(
            Icons.home,
          ),
          onTap: onTap,
        );
      case DrawerItems.addGold:
        return DrawerListTile(
          title: "Altın Yükle",
          icon: const Icon(Icons.money_off_csred_outlined),
          onTap: onTap,
        );
      case DrawerItems.contactUs:
        return DrawerListTile(
          title: "Bize Ulaşın",
          icon: const Icon(Icons.mail_outline),
          onTap: onTap,
        );
      case DrawerItems.termsOfService:
        return DrawerListTile(
          title: "Kullanım Koşulları",
          icon: const Icon(Icons.find_in_page_outlined),
          onTap: onTap,
        );
      case DrawerItems.privacyPolicy:
        return DrawerListTile(
          title: "Gizlilik Politikası",
          icon: const Icon(Icons.find_in_page_outlined),
          onTap: onTap,
        );
      case DrawerItems.feedback:
        return DrawerListTile(
          title: "Uygulamayı Puanla",
          icon: const Icon(Icons.star_border_outlined),
          onTap: onTap,
        );
      case DrawerItems.settings:
        return DrawerListTile(
          title: "Ayarlar",
          icon: const Icon(
            Icons.settings,
          ),
          onTap: onTap,
        );
      default:
        return DrawerListTile(
          title: "Unknown",
          icon: const Icon(
            Icons.help,
          ),
          onTap: onTap,
        );
    }
  }
}
