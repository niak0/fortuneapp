import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../user_setup_view_model.dart';

class LocationStep extends StatelessWidget {
  const LocationStep({super.key});

  @override
  Widget build(BuildContext context) {
    final UserSetupViewModel viewModel = context.read<UserSetupViewModel>();
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Hangi şehirde doğdun?"),
          TextField(
            controller: controller,
            onChanged: (value) => viewModel.updateUser(location: value),
            decoration: const InputDecoration(
              labelText: "Doğum Yeri",
              suffixIcon: Icon(Icons.edit_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
