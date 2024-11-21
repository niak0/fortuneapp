import 'package:flutter/material.dart';
import 'package:fortuneapp/features/fortune_coffee/fortune_coffee_view.dart';
import 'package:fortuneapp/features/fortune_coffee/widgets/fortune_topic_card.dart';
import 'package:fortuneapp/features/fortune_coffee/widgets/photo_picker.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/custom_grid.dart';
import '../../enums/fortune_topic.dart';
import 'fortune_coffee_view_model.dart';

mixin FortuneCoffeeViewMixin on State<FortuneCoffeeView> {
  final userInfoController = TextEditingController();
  final chosePhotoText = "Fincan Fotoğraflarını Seç";
  final choseFortuneContentText = "Fal konusunu Seç";
  final snackbarText = "Lütfen tüm fotoğrafları seçin ve bir fal türü belirleyin.";
  final buttonText = "Yorumla";

  Text titleMessage(BuildContext context, String text) => Text(text, style: Theme.of(context).textTheme.headlineSmall);

  Widget buildUserIntoTextField(VoidCallback onPressed) {
    return TextField(
      controller: userInfoController,
      onTap: onPressed,
      readOnly: true,
      autofocus: false,
      decoration: InputDecoration(
          suffixIcon: const Icon(Icons.pending_actions),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }

  Widget buildPhotoPicker() {
    return Consumer<FortuneCoffeeViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          children: List.generate(
            viewModel.photos.length,
                (index) {
                return Expanded(
                  child: PhotoPicker(
                      onPhotoTap: () async {
                        await viewModel.pickPhoto(index);
                      },
                      onDeleteTap: () {
                        viewModel.deletePhoto(index);
                      },
                      photo: viewModel.photos[index]));
            },
          ),
        );
      },
    );
  }
  Widget buildCustomGrid() {
    return Consumer<FortuneCoffeeViewModel>(
      builder: (context, viewModel, child) {
        return CustomGrid(
          itemCount: FortuneTopic.values.length,
          itemBuilder: (context, index) {
            final topic = FortuneTopic.values[index];
            return GestureDetector(
              onTap: () {
                viewModel.selectFortuneTopic(topic);
              },
              child: FortuneTopicCard(
                selectedFortuneTopic: viewModel.selectedFortuneTopic,
                fortuneTopicOption: topic,
              ),
            );
          },
        );
      },
    );
  }
}
