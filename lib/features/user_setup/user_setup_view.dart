import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/current_user.dart';
import 'user_setup_view_model.dart';

class UserSetupView extends StatelessWidget {
  const UserSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = context.read<CurrentUser>();

    return ChangeNotifierProvider(
      create: (context) => UserSetupViewModel(currentUser),
      child: Consumer<UserSetupViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
              appBar: AppBar(title: Text("Adım ${viewModel.currentStep + 1}")),
              body: Column(
                children: [
                  LinearProgressIndicator(value: (viewModel.currentStep + 1) / viewModel.steps.length),
                  Expanded(
                    child: PageView.builder(
                      controller: viewModel.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) => viewModel.updateCurrentStep(index),
                      itemCount: viewModel.steps.length,
                      itemBuilder: (context, index) {
                        return viewModel.steps[index];
                      },
                    ),
                  )
                ],
              ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: viewModel.currentStep > 0 ? viewModel.previousStep : null,
                        child: const Text("Geri"),
                      ),
                      ElevatedButton(
                        onPressed: viewModel.nextStep,
                        child: Text(viewModel.isLastStep ? "Kaydet!" : "İleri"),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
