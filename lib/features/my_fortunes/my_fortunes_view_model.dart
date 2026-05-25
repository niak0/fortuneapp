import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/fortune_model.dart';
import '../../core/network/mock_service.dart';

part 'my_fortunes_view_model.g.dart';

// Kullanıcının tüm fal geçmişini stream olarak yayınlar.
@riverpod
class MyFortunesViewModel extends _$MyFortunesViewModel {
  @override
  Stream<List<ContentModel>> build() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      final fortunes = await MockService.getFortuneHistory();
      yield fortunes
          .map((f) => ContentModel(
                id: f['id'],
                createdTime: f['createdTime'],
                unlockTime: f['unlockTime'],
                fortune: f['fortune'],
                userId: f['userId'],
                fortuneType: f['fortuneType'],
                fortuneTopic: f['fortuneTopic'],
                isRead: f['isRead'],
                isAccessible: f['isAccessible'],
              ))
          .toList();
    }
  }

  // Falı okundu olarak işaretler.
  Future<void> markAsRead(String fortuneId) async {
    await MockService.markFortuneAsRead(fortuneId);
  }

  // Falı erişilebilir hale getirir.
  Future<void> makeFortuneAccessible(String fortuneId) async {
    await MockService.makeFortuneAccessible(fortuneId);
  }
}
