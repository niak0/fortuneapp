import 'package:fortuneapp/enums/gpt_content_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/auth/current_user.dart';
import '../../core/data/fortune_repository.dart';
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

  // Bekleyen rüya tabiri kaydı oluşturur; yorum arka planda üretilir.
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

    await gold.decreaseGold(kFortuneCost);
    final ok = await ref
        .read(fortuneRepositoryProvider)
        .create(
          contentType: ContentType.dream,
          request: {
            'userContext': buildUserContext(user),
            'dreamText': state.dreamText.trim(),
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
}
