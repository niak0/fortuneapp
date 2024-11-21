import 'package:flutter/material.dart';
import '../../core/models/fortune_model.dart';
import '../../core/network/mock_service.dart';

class MyFortunesViewModel extends ChangeNotifier {
  Stream<List<ContentModel>> get fortunesStream async* {
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

  Future<void> markAsRead(String fortuneId) async {
    await MockService.markFortuneAsRead(fortuneId);
    notifyListeners();
  }

  Future<void> makeFortuneAccessible(String fortuneId) async {
    await MockService.makeFortuneAccessible(fortuneId);
    notifyListeners();
  }
}
