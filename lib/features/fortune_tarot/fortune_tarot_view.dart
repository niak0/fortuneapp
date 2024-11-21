import 'package:flutter/material.dart';
import 'package:fortuneapp/core/navigation/app_navigator_manager.dart';
import 'package:fortuneapp/features/fortune_tarot/positioned_circle_container.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/loading_dialog.dart';
import '../../core/models/current_user.dart';
import 'fortune_tarot_view_model.dart';

class FortuneTarotView extends StatelessWidget {
  const FortuneTarotView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentUser = context.read<CurrentUser>().currentUser!;

    return ChangeNotifierProvider(
      create: (context) => FortuneTarotViewModel(currentUser)..initCards(),
      child: Consumer<FortuneTarotViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.cards == null) {
            return const Center(child: LoadingDialog());
          }
          return Scaffold(
            appBar: AppBar(title: Text("Tarot")),
            body: Column(
              children: [
                Text("Kartlarını seç", style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 10),
                _buildDrawAreas(viewModel),
                const SizedBox(height: 20),
                Text("Çarkı sağa-sola çevir", style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 10),
                _buildRotatingWheel(size, viewModel),
                Text("Seçmek istediğin karta dokun!", style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 50),
                viewModel.selectedCards.values.every((card) => card != null) ? buildElevatedButton(context, viewModel) : const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildElevatedButton(BuildContext context, FortuneTarotViewModel viewModel) {
    return ElevatedButton(
      onPressed: () async {
        LoadingDialog.show(context);
        await viewModel.handleSelectedCards();
        if (context.mounted) {
          LoadingDialog.hide(context);
          AppNavigatorManager.instance.pop();
        }
      },
      style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
      child: const Text("Devam Et"),
    );
  }

  Widget _buildDrawAreas(FortuneTarotViewModel viewModel) {
    final labels = ["Geçmiş", "Şimdi", "Gelecek"];

    // Boş olan ilk alanı bul (aktif olan alan)
    String? nextEmptyArea = viewModel.selectedCards.entries.firstWhere((entry) => entry.value == null, orElse: () => const MapEntry("", null)).key;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(labels.length, (index) {
        String drawArea = labels[index]; // Her alanın adı

        return Column(
          children: [
            Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(
                  // Eğer bu alan boş ve sıradaki alan ise kahverengi yapıyoruz, değilse gri
                  color: drawArea == nextEmptyArea ? Colors.brown : Colors.grey,
                  width: 3,
                ),
              ),
              child: viewModel.selectedCards[drawArea] != null
                  ? Image.asset(
                      "assets/tarot/${viewModel.cards![viewModel.selectedCards[drawArea]!].img}",
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
      }),
    );
  }

  Widget _buildRotatingWheel(Size size, FortuneTarotViewModel viewModel) {
    final double radius = size.width / 1.1;

    return GestureDetector(
      onPanUpdate: (details) => viewModel.rotateWheel(details.delta.dx * 0.003),
      onTap: viewModel.handleTapOnCard,
      child: Container(
        color: Colors.transparent,
        width: size.width,
        height: size.height / 4.3,
        child: Stack(
          children: [
            for (int i = 0; i < viewModel.cards!.length; i++)
              PositionedCircleContainer(
                index: i,
                totalContainers: viewModel.cards!.length,
                radius: radius,
                angle: viewModel.angle,
                screenSize: size,
              ),
          ],
        ),
      ),
    );
  }
}
