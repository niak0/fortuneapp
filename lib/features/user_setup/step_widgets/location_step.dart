import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../user_setup_view_model.dart';

// Kullanıcı kurulumu — doğum yeri adımı.
class LocationStep extends ConsumerStatefulWidget {
  const LocationStep({super.key});

  @override
  ConsumerState<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends ConsumerState<LocationStep> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(userSetupViewModelProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hangi şehirde doğdun?'),
          TextField(
            controller: _controller,
            onChanged: (value) => notifier.updateUser(location: value),
            decoration: const InputDecoration(
              labelText: 'Doğum Yeri',
              suffixIcon: Icon(Icons.edit_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
