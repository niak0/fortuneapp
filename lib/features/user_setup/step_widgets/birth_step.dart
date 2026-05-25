import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../user_setup_view_model.dart';

// Kullanıcı kurulumu — doğum tarihi/saati adımı.
class BirthStep extends ConsumerStatefulWidget {
  const BirthStep({super.key});

  @override
  ConsumerState<BirthStep> createState() => _BirthStepState();
}

class _BirthStepState extends ConsumerState<BirthStep> {
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _birthTimeController = TextEditingController();

  @override
  void dispose() {
    _birthDateController.dispose();
    _birthTimeController.dispose();
    super.dispose();
  }

  Future<void> _showTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    final notifier = ref.read(userSetupViewModelProvider.notifier);
    final user = ref.read(userSetupViewModelProvider).user;
    final finalDateTime = DateTime(
      user.birthDate.year,
      user.birthDate.month,
      user.birthDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    notifier.updateUser(birthDate: finalDateTime);
    setState(() {
      _birthTimeController.text = DateFormat('HH:mm').format(finalDateTime);
    });
  }

  Future<void> _showDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    _birthDateController.text = DateFormat('dd.MM.yyyy').format(pickedDate);
    ref.read(userSetupViewModelProvider.notifier).updateUser(birthDate: pickedDate);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userSetupViewModelProvider);
    final notifier = ref.read(userSetupViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Merhaba, ${state.user.name}!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextField(
            controller: _birthDateController,
            readOnly: true,
            onTap: _showDatePicker,
            decoration: const InputDecoration(
              labelText: 'Doğum Tarihin nedir?',
              suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _birthTimeController,
            readOnly: true,
            enabled: !state.isChecked,
            onTap: _showTimePicker,
            decoration: const InputDecoration(
              labelText: 'Doğum Saati nedir?',
              suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
          CheckboxListTile(
            title: const Text('Doğum saatimi bilmiyorum'),
            value: state.isChecked,
            onChanged: (value) {
              notifier.toggleChecked(value ?? false);
              if (value ?? false) _birthTimeController.clear();
            },
          ),
        ],
      ),
    );
  }
}
