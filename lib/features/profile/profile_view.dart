import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/current_user.dart';
import '../../core/models/user_model.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/theme/mystic_tokens.dart';
import '../../enums/gender_options.dart';
import '../../enums/relationship_status.dart';
import '../../enums/work_status.dart';
import '../../enums/zodiac_sign.dart';

// Kullanıcının profil özet ekranı.
class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider.select((value) => value.value));
    return Scaffold(
      appBar: AppBar(title: const Text('Profilim')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _ProfileCard(
          user: user,
          onEdit: () =>
              ref.read(appNavigatorProvider).pushToPage(AppRoutes.profileEdit),
        ),
      ),
    );
  }
}

// Avatar + isim + burç + demografik bilgileri gösteren profil kartı.
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.user, required this.onEdit});

  final UserModel? user;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final user = this.user;
    if (user == null) return const Card();

    final tokens = MysticTokens.of(context);
    final zodiac = ZodiacSign.values
        .where((z) => z.name == user.zodiacSign)
        .firstOrNull;
    final gender = GenderOption.values
        .where((g) => g.name == user.gender)
        .firstOrNull
        ?.displayName;
    final work = WorkStatus.values
        .where((w) => w.name == user.workState)
        .firstOrNull
        ?.turkishName;
    final relationship = RelationshipStatus.values
        .where((r) => r.name == user.relationshipState)
        .firstOrNull
        ?.turkishName;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: tokens.line,
                  child: Text(
                    zodiac?.symbol ?? '✦',
                    style: TextStyle(fontSize: 30, color: tokens.gold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.name}, ${user.age ?? "?"}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (zodiac != null)
                        Text(
                          zodiac.turkishName,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: tokens.inkSoft),
                        ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Düzenle'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: tokens.line),
            _InfoRow(icon: Icons.location_on_outlined, value: user.location),
            if (gender != null)
              _InfoRow(icon: Icons.person_outline, value: gender),
            if (work != null) _InfoRow(icon: Icons.work_outline, value: work),
            if (relationship != null)
              _InfoRow(icon: Icons.favorite_outline, value: relationship),
          ],
        ),
      ),
    );
  }
}

// İkon + değer içeren tek satır bilgi.
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    final tokens = MysticTokens.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: tokens.gold),
          const SizedBox(width: 12),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
