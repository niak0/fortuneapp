import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../user_setup_view_model.dart';

class BirthStep extends StatefulWidget {
  const BirthStep({super.key});

  @override
  State<BirthStep> createState() => _BirthStepState();
}

class _BirthStepState extends State<BirthStep> {
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController birthTimeController = TextEditingController();

  Future<void> _showTimePicker(BuildContext context, UserSetupViewModel viewModel) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      DateTime finalDateTime = DateTime(
        viewModel.user.birthDate.year,
        viewModel.user.birthDate.month,
        viewModel.user.birthDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      viewModel.updateUser(birthDate: finalDateTime);
      setState(() {
        birthTimeController.text = DateFormat('HH:mm').format(finalDateTime);
      });
    }
  }

  Future<void> _showDatePicker(BuildContext context, UserSetupViewModel viewModel) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      birthDateController.text = DateFormat('dd.MM.yyyy').format(pickedDate);
      viewModel.updateUser(birthDate: pickedDate);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserSetupViewModel viewModel = context.watch<UserSetupViewModel>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Merhaba, ${viewModel.user.name}!",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextField(
            controller: birthDateController,
            readOnly: true,
            onTap: () async {
              _showDatePicker(context, viewModel);
            },
            decoration: const InputDecoration(
              labelText: "Doğum Tarihin nedir?",
              suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: birthTimeController,
            readOnly: true,
            enabled: !viewModel.isChecked,
            onTap: () async {
              _showTimePicker(context, viewModel);
            },
            decoration: const InputDecoration(
              labelText: "Doğum Saati nedir?",
              suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
          CheckboxListTile(
            title: const Text('Doğum saatimi bilmiyorum'),
            value: viewModel.isChecked,
            onChanged: (value) {
                viewModel.toggleChecked(value!);
                if (value) {
                  birthTimeController.clear();
                }
            },
          ),
        ],
      ),
    );
  }
}
