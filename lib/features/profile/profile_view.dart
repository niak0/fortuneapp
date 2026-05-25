import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/current_user.dart';
import '../../core/models/user_model.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/navigation/app_navigator_manager.dart';
import '../../enums/zodiac_sign.dart';

// Kullanıcının profil özet ekranı.
class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(
      currentUserProvider.select((value) => value.value),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save_alt_outlined),
          ),
          IconButton(
            onPressed: () => AppNavigatorManager.instance.pop(),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: buildProfileCard(
              context,
              user,
              () => AppNavigatorManager.instance.pushToPage(AppRoutes.profileEdit),
            ),
          ),
        ],
      ),
    );
  }
}

// İstatistik kartı (henüz boş).
Widget buildStats(BuildContext context) => const Card();

// Avatar + isim + burç içeren profil kartı.
Widget buildProfileCard(
  BuildContext context,
  UserModel? user,
  VoidCallback onPressed,
) {
  if (user == null) return const Card();

  return Card(
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      trailing: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Düzenle'),
      ),
      leading: const CircleAvatar(
        radius: 30,
        child: Icon(Icons.man, size: 50),
      ),
      subtitle: Text(
        ZodiacSign.values
            .firstWhere(
              (z) => z.name == user.zodiacSign,
              orElse: () => ZodiacSign.aries,
            )
            .turkishName,
      ),
      title: Text('${user.name}, ${user.age}'),
    ),
  );
}
