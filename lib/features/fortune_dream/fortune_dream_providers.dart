import 'package:fortuneapp/enums/gpt_content_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/auth/current_user.dart';
import '../../core/data/fortune_repository.dart';
import '../../core/network/gpt_service.dart';
import '../../core/network/prompt_builder.dart';
import '../../core/ui/ui_helper.dart';
import '../../core/utilities/gold_manager.dart';
import 'fortune_dream_state.dart';

export 'fortune_dream_state.dart';

part 'fortune_dream_providers.g.dart';

// Rüya tabiri akışı için Notifier — metni tutar, GPT'den yorum üretip kaydeder.
@riverpod
class FortuneDreamViewModel extends _$FortuneDreamViewModel {
  @override
  FortuneDreamState build() => const FortuneDreamState();

  // Yazılan rüya metnini günceller.
  void setDreamText(String value) {
    state = state.copyWith(dreamText: value);
  }

  // GPT'den rüya yorumu alır, kaydeder ve altını düşer. Başarılıysa true döner.
  Future<bool> submit() async {
    if (!state.isValid) return false;

    final user = ref.read(currentUserProvider).value;
    if (user == null) return false;

    final ui = ref.read(uiHelperProvider);
    final gold = ref.read(goldManagerProvider);
    if (!gold.checkGoldAndProceed(kFortuneCost)) {
      ui.showSnackBar('Yeterli altının yok');
      return false;
    }

    final prompt =
        '${buildUserContext(user)}. Görülen rüya: ${state.dreamText.trim()}. '
        'Bu rüyayı sembolik ve derin bir şekilde yorumla.';

    final text = await ref
        .read(gptServiceProvider)
        .createMessage(message: prompt, contentType: ContentType.dream);
    if (text == null) {
      ui.showSnackBar('Fal alınamadı, lütfen tekrar dene');
      return false;
    }

    final ok = await ref
        .read(fortuneRepositoryProvider)
        .add(content: text, contentType: ContentType.dream);
    if (!ok) {
      ui.showSnackBar('Fal kaydedilemedi');
      return false;
    }

    await gold.decreaseGold(kFortuneCost);
    return true;
  }
}
