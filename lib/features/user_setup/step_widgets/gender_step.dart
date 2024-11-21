import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../user_setup_view_model.dart';

class GenderStep extends StatelessWidget {
  const GenderStep({
    super.key});

  @override
  Widget build(BuildContext context) {
    final UserSetupViewModel viewModel = context.watch<UserSetupViewModel>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            "Cinsiyetini Seç:",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Row(
            children: GenderEnum.values.map((gender) => GenderOption(
                  title: gender.turkishName,
                  isSelected: viewModel.user.gender == gender.name,
                  icon: gender.icon,
                  onTap: () => viewModel.updateUser(gender: gender.name),
                )).toList(),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => viewModel.updateUser(gender: 'lgbtq'),
            child: Row(
              children: [
                Checkbox(
                  value: viewModel.user.gender == 'lgbtq',
                  onChanged: (bool? value) {
                    if (value == true) {
                      viewModel.updateUser(gender: 'lgbtq');
                    } else {
                      viewModel.updateUser(gender: ''); // Eğer checkbox kaldırılırsa, seçimi boşalt.
                    }
                  },
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
                 Text(
                  'LGBTQ',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
    final ThemeData theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onPrimary,
            border: Border.all(color: theme.colorScheme.onSurface),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: theme.colorScheme.onSurface,
                size: 50,
              ),
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
  // lgbtq('LGBTQ', Icons.hourglass_bottom_sharp);

  final String turkishName;
  final IconData icon;
  const GenderEnum(this.turkishName, this.icon);

  static dynamic fromApi(String apiValue) {
    try {
      if (kDebugMode) {
        print("Türkçe karşılık var, Türkçe değeri döndürülüyor.");
      }
      return GenderEnum.values.firstWhere(
            (sign) => sign.name.toLowerCase() == apiValue.toLowerCase(),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Türkçe karşılık bulunamadı, API değeri döndürülüyor.");
      }
      return apiValue;
    }
  }
}
