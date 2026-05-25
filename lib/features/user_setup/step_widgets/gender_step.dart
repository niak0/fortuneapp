import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../user_setup_view_model.dart';

// Kullanıcı kurulumu — cinsiyet seçim adımı.
class GenderStep extends ConsumerWidget {
  const GenderStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userSetupViewModelProvider);
    final notifier = ref.read(userSetupViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cinsiyetini Seç:',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Row(
            children: GenderEnum.values
                .map((gender) => GenderOption(
                      title: gender.turkishName,
                      isSelected: state.user.gender == gender.name,
                      icon: gender.icon,
                      onTap: () => notifier.updateUser(gender: gender.name),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => notifier.updateUser(gender: 'lgbtq'),
            child: Row(
              children: [
                Checkbox(
                  value: state.user.gender == 'lgbtq',
                  onChanged: (value) {
                    if (value == true) {
                      notifier.updateUser(gender: 'lgbtq');
                    } else {
                      notifier.updateUser(gender: '');
                    }
                  },
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
                Text(
                  'LGBTQ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Cinsiyet seçenek kartı.
class GenderOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const GenderOption({
    super.key,
    required this.title,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onPrimary,
            border: Border.all(color: theme.colorScheme.onSurface),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: theme.colorScheme.onSurface, size: 50),
              Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum GenderEnum {
  female('Kadın', Icons.female),
  male('Erkek', Icons.male);

  final String turkishName;
  final IconData icon;
  const GenderEnum(this.turkishName, this.icon);

  static dynamic fromApi(String apiValue) {
    try {
      if (kDebugMode) print('Türkçe karşılık var, Türkçe değeri döndürülüyor.');
      return GenderEnum.values.firstWhere(
        (sign) => sign.name.toLowerCase() == apiValue.toLowerCase(),
      );
    } catch (e) {
      if (kDebugMode) print('Türkçe karşılık bulunamadı, API değeri döndürülüyor.');
      return apiValue;
    }
  }
}
