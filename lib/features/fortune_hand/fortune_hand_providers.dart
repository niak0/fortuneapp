import 'package:fortuneapp/enums/gpt_content_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/auth/current_user.dart';
import '../../core/data/fortune_repository.dart';
import '../../core/network/prompt_builder.dart';
import '../../core/ui/ui_helper.dart';
import '../../core/utilities/gold_manager.dart';
import 'fortune_hand_state.dart';

export 'fortune_hand_state.dart';

part 'fortune_hand_providers.g.dart';

// El falı akışı için Notifier — fotoğrafı tutar, GPT'den yorum üretip kaydeder.
@riverpod
class FortuneHandViewModel extends _$FortuneHandViewModel {
  @override
  FortuneHandState build() => const FortuneHandState();

  // Kameradan fotoğraf çeker ve state'e alır.
  Future<void> pickPhoto() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    state = state.copyWith(photoPath: image.path);
  }

  // Bekleyen el falı kaydı oluşturur; yorum arka planda üretilir.
  Future<bool> submit() async {
    if (!state.hasPhoto) return false;

    final user = ref.read(currentUserProvider).value;
    if (user == null) return false;

    final ui = ref.read(uiHelperProvider);
    final gold = ref.read(goldManagerProvider);
    if (!gold.checkGoldAndProceed(kFortuneCost)) {
      ui.showSnackBar('Yeterli altının yok');
      return false;
    }

    await gold.decreaseGold(kFortuneCost);
    final ok = await ref
        .read(fortuneRepositoryProvider)
        .create(
          contentType: ContentType.hand,
          request: {'userContext': buildUserContext(user)},
        );
    if (!ok) {
      await gold.increaseGold(amount: kFortuneCost);
      ui.showSnackBar('Fal başlatılamadı, lütfen tekrar dene');
      return false;
    }

    ui.showSnackBar('Falın hazırlanıyor, birazdan hazır olacak ✨');
    return true;
  }
}
