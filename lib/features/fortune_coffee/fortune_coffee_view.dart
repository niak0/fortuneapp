import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/navigation/app_navigator.dart';
import 'package:fortuneapp/core/widgets/loading_dialog.dart';
import 'package:fortuneapp/core/widgets/snackbar.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/relationship_status.dart';
import 'package:fortuneapp/enums/work_status.dart';

import '../../core/auth/current_user.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_grid.dart';
import 'fortune_coffee_providers.dart';
import 'widgets/fortune_topic_card.dart';
import 'widgets/photo_picker.dart';

// Kahve falı için fotoğraf ve fal konusu seçilen ekran.
class FortuneCoffeeView extends ConsumerStatefulWidget {
  const FortuneCoffeeView({super.key});

  @override
  ConsumerState<FortuneCoffeeView> createState() => _FortuneCoffeeViewState();
}

class _FortuneCoffeeViewState extends ConsumerState<FortuneCoffeeView> {
  final TextEditingController _userInfoController = TextEditingController();
  static const _chosePhotoText = 'Fincan Fotoğraflarını Seç';
  static const _choseFortuneContentText = 'Fal konusunu Seç';
  static const _snackbarText =
      'Lütfen tüm fotoğrafları seçin ve bir fal türü belirleyin.';
  static const _buttonText = 'Yorumla';

  @override
  void dispose() {
    _userInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final state = ref.watch(fortuneCoffeeViewModelProvider);
    final notifier = ref.read(fortuneCoffeeViewModelProvider.notifier);

    return currentUserAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Hata: $e'))),
      data: (currentUser) {
        if (currentUser == null) {
          return const Scaffold(body: Center(child: Text('Kullanıcı yok')));
        }
        _userInfoController.text = '${currentUser.gender}, ${currentUser.age}, '
            '${WorkStatus.values.firstWhere((w) => w.name == currentUser.workState).turkishName}, '
            '${RelationshipStatus.values.firstWhere((r) => r.name == currentUser.relationShipState).turkishName}';

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleMessage(context, _chosePhotoText),
                  _PhotoPickerRow(photos: state.photos, notifier: notifier),
                  const SizedBox(height: 10),
                  _buildUserInfoTextField(
                    onTap: () => ref.read(appNavigatorProvider)
                        .pushToPage(AppRoutes.profileEdit),
                  ),
                  const SizedBox(height: 10),
                  _titleMessage(context, _choseFortuneContentText),
                  _TopicGrid(
                    selected: state.selectedFortuneTopic,
                    notifier: notifier,
                  ),
                  CustomButton(
                    text: _buttonText,
                    onPressed: () async {
                      if (!notifier.handleFortuneCreation()) {
                        return CustomSnackBar.show(_snackbarText);
                      }
                      LoadingDialog.show(context);
                      await notifier.getFortuneAndSaveFirebase(currentUser);
                      if (context.mounted) LoadingDialog.hide(context);
                      ref.read(appNavigatorProvider).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Text _titleMessage(BuildContext context, String text) =>
      Text(text, style: Theme.of(context).textTheme.headlineSmall);

  Widget _buildUserInfoTextField({required VoidCallback onTap}) {
    return TextField(
      controller: _userInfoController,
      onTap: onTap,
      readOnly: true,
      autofocus: false,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.pending_actions),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// 3 slotlu fotoğraf seçici.
class _PhotoPickerRow extends StatelessWidget {
  const _PhotoPickerRow({required this.photos, required this.notifier});

  final List<String> photos;
  final FortuneCoffeeViewModel notifier;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(photos.length, (index) {
        return Expanded(
          child: PhotoPicker(
            onPhotoTap: () => notifier.pickPhoto(index),
            onDeleteTap: () => notifier.deletePhoto(index),
            photo: photos[index],
          ),
        );
      }),
    );
  }
}

// Fal konusu grid'i.
class _TopicGrid extends StatelessWidget {
  const _TopicGrid({required this.selected, required this.notifier});

  final FortuneTopic? selected;
  final FortuneCoffeeViewModel notifier;

  @override
  Widget build(BuildContext context) {
    return CustomGrid(
      itemCount: FortuneTopic.values.length,
      itemBuilder: (context, index) {
        final topic = FortuneTopic.values[index];
        return GestureDetector(
          onTap: () => notifier.selectFortuneTopic(topic),
          child: FortuneTopicCard(
            selectedFortuneTopic: selected,
            fortuneTopicOption: topic,
          ),
        );
      },
    );
  }
}
