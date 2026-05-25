import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'step_widgets/birth_step.dart';
import 'step_widgets/gender_step.dart';
import 'step_widgets/name_step.dart';
import 'step_widgets/relationship_step.dart';
import 'step_widgets/work_status_step.dart';
import 'step_widgets/zodiac_step.dart';
import 'user_setup_view_model.dart';

// Çok adımlı kullanıcı kurulum ekranı.
class UserSetupView extends ConsumerStatefulWidget {
  const UserSetupView({super.key});

  @override
  ConsumerState<UserSetupView> createState() => _UserSetupViewState();
}

class _UserSetupViewState extends ConsumerState<UserSetupView> {
  final PageController _pageController = PageController();

  static const List<Widget> _steps = [
    NameStep(),
    BirthStep(),
    ZodiacStep(),
    GenderStep(),
    WorkStatusStep(),
    RelationshipStep(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    final notifier = ref.read(userSetupViewModelProvider.notifier);
    final state = ref.read(userSetupViewModelProvider);
    final wasLast = state.isLastStep;
    final ok = await notifier.nextStep();
    if (!ok || wasLast) return;
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
    );
  }

  Future<void> _previous() async {
    if (ref.read(userSetupViewModelProvider.notifier).previousStep()) {
      await _pageController.previousPage(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userSetupViewModelProvider);
    final notifier = ref.read(userSetupViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Adım ${state.currentStep + 1}')),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (state.currentStep + 1) / userSetupTotalSteps,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: notifier.updateCurrentStep,
              itemCount: _steps.length,
              itemBuilder: (context, index) => _steps[index],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: state.currentStep > 0 ? _previous : null,
                child: const Text('Geri'),
              ),
              ElevatedButton(
                onPressed: _next,
                child: Text(state.isLastStep ? 'Kaydet!' : 'İleri'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
