import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/navigation/app_navigator_manager.dart';
import 'package:fortuneapp/features/fortune_tarot/positioned_circle_container.dart';

import '../../core/widgets/loading_dialog.dart';
import 'fortune_tarot_view_model.dart';

// Tarot çekme ekranı.
class FortuneTarotView extends ConsumerWidget {
  const FortuneTarotView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final asyncState = ref.watch(fortuneTarotViewModelProvider);
    final notifier = ref.read(fortuneTarotViewModelProvider.notifier);

    return asyncState.when(
      loading: () => const Center(child: LoadingDialog()),
      error: (e, _) => Scaffold(body: Center(child: Text('Hata: $e'))),
      data: (state) {
        final cards = state.cards;
        if (cards == null) {
          return const Center(child: LoadingDialog());
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Tarot')),
          body: Column(
            children: [
              Text('Kartlarını seç',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              _buildDrawAreas(state),
              const SizedBox(height: 20),
              Text('Çarkı sağa-sola çevir',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              _buildRotatingWheel(size, state, notifier),
              Text('Seçmek istediğin karta dokun!',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 50),
              if (state.selectedCards.values.every((c) => c != null))
                _buildElevatedButton(context, notifier),
            ],
          ),
        );
      },
    );
  }

  // Tarot devam butonu (yorumlamayı başlatır).
  Widget _buildElevatedButton(
      BuildContext context, FortuneTarotViewModel notifier) {
    return ElevatedButton(
      onPressed: () async {
        LoadingDialog.show(context);
        await notifier.handleSelectedCards();
        if (context.mounted) {
          LoadingDialog.hide(context);
          AppNavigatorManager.instance.pop();
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      child: const Text('Devam Et'),
    );
  }

  // Geçmiş/Şimdi/Gelecek slot'larını çizer.
  Widget _buildDrawAreas(FortuneTarotState state) {
    final labels = ['Geçmiş', 'Şimdi', 'Gelecek'];
    final nextEmptyArea = state.selectedCards.entries
        .firstWhere(
          (entry) => entry.value == null,
          orElse: () => const MapEntry('', null),
        )
        .key;
    final cards = state.cards!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels.map((drawArea) {
        return Column(
          children: [
            Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      drawArea == nextEmptyArea ? Colors.brown : Colors.grey,
                  width: 3,
                ),
              ),
              child: state.selectedCards[drawArea] != null
                  ? Image.asset(
                      'assets/tarot/${cards[state.selectedCards[drawArea]!].img}',
                      fit: BoxFit.fill,
                    )
                  : const Icon(Icons.add_rounded, color: Colors.brown),
            ),
            const SizedBox(height: 10),
            Text(
              drawArea,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        );
      }).toList(),
    );
  }

  // Dönen kart çarkını çizer.
  Widget _buildRotatingWheel(
    Size size,
    FortuneTarotState state,
    FortuneTarotViewModel notifier,
  ) {
    final radius = size.width / 1.1;
    final cards = state.cards!;

    return GestureDetector(
      onPanUpdate: (details) => notifier.rotateWheel(details.delta.dx * 0.003),
      onTap: notifier.handleTapOnCard,
      child: Container(
        color: Colors.transparent,
        width: size.width,
        height: size.height / 4.3,
        child: Stack(
          children: [
            for (int i = 0; i < cards.length; i++)
              PositionedCircleContainer(
                index: i,
                totalContainers: cards.length,
                radius: radius,
                angle: state.angle,
                screenSize: size,
              ),
          ],
        ),
      ),
    );
  }
}
