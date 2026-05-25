import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../enums/zodiac_sign.dart';
import '../user_setup_view_model.dart';

// Kullanıcı kurulumu — burç seçim adımı.
class ZodiacStep extends ConsumerWidget {
  const ZodiacStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userSetupViewModelProvider);
    final notifier = ref.read(userSetupViewModelProvider.notifier);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Burcun nedir?', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 20),
            ...ZodiacSign.values.map(
              (status) => GestureDetector(
                onTap: () => notifier.updateUser(zodiacSign: status.name),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: state.user.zodiacSign == status.name
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onPrimary,
                    border: Border.all(color: theme.colorScheme.onSurface),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      status.turkishName,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
