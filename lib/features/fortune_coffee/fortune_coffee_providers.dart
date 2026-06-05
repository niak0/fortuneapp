import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/data/fortune_repository.dart';
import '../../core/models/user_model.dart';
import '../../core/network/gpt_service.dart';
import '../../core/network/prompt_builder.dart';
import '../../core/ui/ui_helper.dart';
import '../../core/utilities/gold_manager.dart';
import 'fortune_coffee_state.dart';

export 'fortune_coffee_state.dart';

part 'fortune_coffee_providers.g.dart';

// Kahve falı için fotoğraf seçimi ve konu seçimi Notifier'ı.
@riverpod
class FortuneCoffeeViewModel extends _$FortuneCoffeeViewModel {
  @override
  FortuneCoffeeState build() => FortuneCoffeeState.initial();

  bool handleFortuneCreation() => state.isValid;

  // GPT'den kahve falı alır, kaydeder ve altını düşer. Başarılıysa true döner.
  Future<bool> getFortuneAndSaveFirebase(UserModel currentUser) async {
    final topic = state.selectedFortuneTopic;
    if (topic == null) return false;

    final ui = ref.read(uiHelperProvider);
    final gold = ref.read(goldManagerProvider);
    if (!gold.checkGoldAndProceed(kFortuneCost)) {
      ui.showSnackBar('Yeterli altının yok');
      return false;
    }

    final prompt =
        '${buildUserContext(currentUser)}. Fal konusu: ${topic.displayName}. '
        'Kullanıcı fincan fotoğraflarını paylaştı; görsele dayalı sembolik bir '
        'kahve falı yorumu yap.';

    final text = await ref
        .read(gptServiceProvider)
        .createMessage(
          message: prompt,
          contentType: ContentType.coffee,
          fortuneTopic: topic,
        );
    if (text == null) {
      ui.showSnackBar('Fal alınamadı, lütfen tekrar dene');
      return false;
    }

    final ok = await ref
        .read(fortuneRepositoryProvider)
        .add(
          content: text,
          contentType: ContentType.coffee,
          fortuneTopic: topic,
        );
    if (!ok) {
      ui.showSnackBar('Fal kaydedilemedi');
      return false;
    }

    await gold.decreaseGold(kFortuneCost);
    return true;
  }

  // Galeriden foto seçer ve slot'u günceller.
  Future<void> pickPhoto(int index) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final newPhotos = List<String>.from(state.photos);
    newPhotos[index] = image.path;
    state = state.copyWith(photos: newPhotos);
  }

  // Slot'taki fotoğrafı temizler.
  void deletePhoto(int index) {
    final newPhotos = List<String>.from(state.photos);
    newPhotos[index] = '';
    state = state.copyWith(photos: newPhotos);
  }

  // Fal konusunu seçer.
  void selectFortuneTopic(FortuneTopic topic) {
    state = state.copyWith(selectedFortuneTopic: topic);
  }
}
