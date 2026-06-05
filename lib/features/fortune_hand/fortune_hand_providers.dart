import 'package:fortuneapp/enums/gpt_content_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/auth/current_user.dart';
import '../../core/data/fortune_repository.dart';
import '../../core/network/gpt_service.dart';
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

  // GPT'den el falı yorumu alır, kaydeder ve altını düşer. Başarılıysa true.
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

    final prompt =
        '${buildUserContext(user)}. Kullanıcı avuç içi fotoğrafını paylaştı; '
        'el çizgilerine dayalı sembolik bir el falı yorumu yap.';

    final text = await ref
        .read(gptServiceProvider)
        .createMessage(message: prompt, contentType: ContentType.hand);
    if (text == null) {
      ui.showSnackBar('Fal alınamadı, lütfen tekrar dene');
      return false;
    }

    final ok = await ref
        .read(fortuneRepositoryProvider)
        .add(content: text, contentType: ContentType.hand);
    if (!ok) {
      ui.showSnackBar('Fal kaydedilemedi');
      return false;
    }

    await gold.decreaseGold(kFortuneCost);
    return true;
  }
}
