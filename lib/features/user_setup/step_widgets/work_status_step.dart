import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../enums/work_status.dart';
import '../user_setup_view_model.dart';

// Kullanıcı kurulumu — çalışma durumu seçim adımı.
class WorkStatusStep extends ConsumerWidget {
  const WorkStatusStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userSetupViewModelProvider);
    final notifier = ref.read(userSetupViewModelProvider.notifier);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Çalışma durumun nedir?', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 20),
          ...WorkStatus.values.map(
            (status) => GestureDetector(
              onTap: () => notifier.updateUser(workState: status.name),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: state.user.workState == status.name
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onPrimary,
                  border: Border.all(color: Colors.white),
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
    );
  }
}
