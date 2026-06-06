import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/fortune_model.dart';
import '../ui/ui_helper.dart';
import '../utilities/gold_manager.dart';
import 'fortune_repository.dart';

part 'fortune_refund_watcher.g.dart';

// Arka plan üretimi başarısız olan ('error') falları izler; altını iade eder,
// kullanıcıyı bilgilendirir ve kaydı siler (tekrar tetiklenmemesi için).
// keepAlive: uygulama açıkken sürekli dinler; MyApp tarafından canlı tutulur.
@Riverpod(keepAlive: true)
class FortuneRefundWatcher extends _$FortuneRefundWatcher {
  final Set<String> _handled = {};

  @override
  void build() {
    final sub = ref.watch(fortuneRepositoryProvider).watchAll().listen(_onData);
    ref.onDispose(sub.cancel);
  }

  Future<void> _onData(List<FortuneModel> fortunes) async {
    for (final fortune in fortunes) {
      final id = fortune.id;
      if (id == null || !fortune.isErrored || _handled.contains(id)) continue;
      _handled.add(id);
      await ref.read(goldManagerProvider).increaseGold(amount: kFortuneCost);
      ref.read(uiHelperProvider).showSnackBar('Fal alınamadı, altının iade edildi');
      await ref.read(fortuneRepositoryProvider).delete(id);
    }
  }
}
