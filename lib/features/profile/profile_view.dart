import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/navigation/app_navigator_manager.dart';
import '../../enums/zodiac_sign.dart';
import '../../core/models/current_user.dart';
import '../../core/models/user_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUser>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilim"),
        actions: [
          IconButton(
            onPressed: () {
              // Save action
            },
            icon: const Icon(Icons.save_alt_outlined),
          ),
          IconButton(
            onPressed: () async {
              AppNavigatorManager.instance.pop();
            },
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
              currentUser.currentUser,
              () {
                AppNavigatorManager.instance.pushToPage(AppRoutes.profileEdit);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildStats(BuildContext context) {
  return const Card();
}

Widget buildProfileCard(BuildContext context, UserModel? user, VoidCallback onPressed) {
  if (user == null) return const Card();

  return Card(
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      trailing: TextButton.icon(onPressed: onPressed, icon: const Icon(Icons.edit_outlined), label: const Text("Düzenle")),
      leading: const CircleAvatar(
        radius: 30,
        child: Icon(
          Icons.man,
          size: 50,
        ),
      ),
      subtitle: Text(
        ZodiacSign.values
            .firstWhere(
              (z) => z.name == user.zodiacSign,
              orElse: () => ZodiacSign.aries,
            )
            .turkishName,
      ),
      title: Text("${user.name}, ${user.age}"),
    ),
  );
}
