import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../user_setup_providers.dart';

// Kullanıcı kurulumu — ad girişi adımı.
class NameStep extends ConsumerStatefulWidget {
  const NameStep({super.key});

  @override
  ConsumerState<NameStep> createState() => _NameStepState();
}

class _NameStepState extends ConsumerState<NameStep> {
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
          const Text(
            'Öncelikle seni tanıyalım.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextFormField(
            controller: _controller,
            onChanged: (value) => notifier.updateUser(name: value),
            decoration: const InputDecoration(
              labelText: 'Adın nedir?',
              suffixIcon: Icon(Icons.edit_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
