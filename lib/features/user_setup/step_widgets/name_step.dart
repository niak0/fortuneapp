import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_setup_view_model.dart';


class NameStep extends StatelessWidget {
   NameStep({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserSetupViewModel viewModel = context.read<UserSetupViewModel>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Öncelikle seni tanıyalım.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextFormField(
            controller: _controller,
            onChanged: (value) {
              viewModel.updateUser(name: value); // ViewModel'de name alanını güncelle
            },
            decoration: const InputDecoration(
              labelText: "Adın nedir?",
              suffixIcon: Icon(Icons.edit_outlined),
            ),
          ),
        ],
      ),
    );
  }
}