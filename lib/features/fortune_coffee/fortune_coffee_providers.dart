import 'dart:convert';
import 'dart:io';

import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/data/fortune_repository.dart';
import '../../core/models/user_model.dart';
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

  // Bekleyen kahve falı oluşturur; vision yorumu arka planda üretilir.
  Future<bool> getFortuneAndSaveFirebase(UserModel currentUser) async {
    final topic = state.selectedFortuneTopic;
    if (topic == null) return false;

    final ui = ref.read(uiHelperProvider);
    final gold = ref.read(goldManagerProvider);
    if (!gold.checkGoldAndProceed(kFortuneCost)) {
      ui.showSnackBar('Yeterli altının yok');
      return false;
    }

    // Dolu fotoğraf slot'larını base64'e çevir (vision payload, pending doc'a).
    final images = await _encodePhotos();

    await gold.decreaseGold(kFortuneCost);
    final ok = await ref
        .read(fortuneRepositoryProvider)
        .create(
          contentType: ContentType.coffee,
          fortuneTopic: topic,
          request: {
            'userContext': buildUserContext(currentUser),
            'topicLabel': topic.displayName,
            'images': images,
          },
        );
    if (!ok) {
      await gold.increaseGold(amount: kFortuneCost);
      ui.showSnackBar('Fal başlatılamadı, lütfen tekrar dene');
      return false;
    }

    ui.showSnackBar('Falın hazırlanıyor, birazdan hazır olacak ✨');
    return true;
  }

  // Dolu fotoğraf slot'larını okuyup base64 listesine çevirir (vision payload).
  Future<List<String>> _encodePhotos() async {
    final images = <String>[];
    for (final path in state.photos) {
      if (path.isEmpty) continue;
      final bytes = await File(path).readAsBytes();
      images.add(base64Encode(bytes));
    }
    return images;
  }

  // Galeriden foto seçer ve slot'u günceller (vision maliyeti için küçültülür).
  Future<void> pickPhoto(int index) async {
    final picker = ImagePicker();
    // Küçült: 3 base64 görsel Firestore 1MB doc limitine sığmalı; vision
    // detail:"low" zaten 512px kullandığı için kalite kaybı önemsiz.
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 768,
      imageQuality: 55,
    );
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
