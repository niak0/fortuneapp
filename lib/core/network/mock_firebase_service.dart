import 'package:flutter/foundation.dart';
import '../../core/models/fortune_model.dart';
import '../../core/models/user_model.dart';
import 'mock_service.dart';

abstract class IFirebaseService {
  Future<void> saveUserToFireStore(UserModel user);
  Future<UserModel?> getUserFromFireStore(String userId);
  void deleteUserFromFirestore();
  Future<bool> addFortune({required String content, required String contentType, required String? fortuneTopic});
  Stream<List<ContentModel>> getUserFortunesStream();
  Future<void> setFortuneAccess(String fortuneId);
  Future<void> markAsRead(String fortuneId);
  Future<void> deleteFortune(String documentId);
}

class MockFirebaseService implements IFirebaseService {
  @override
  Future<void> saveUserToFireStore(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    MockService.mockUser.name = user.name;
  }

  @override
  Future<UserModel?> getUserFromFireStore(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockService.mockUser;
  }

  @override
  void deleteUserFromFirestore() {}

  @override
  Future<bool> addFortune({
    required String content,
    required String contentType,
    required String? fortuneTopic,
  }) async {
    try {
      final fortune = {
        'id': 'fortune_${DateTime.now().millisecondsSinceEpoch}',
        'type': contentType,
        'date': DateTime.now(),
        'result': content,
        'topic': fortuneTopic,
        'isRead': false,
        'isAccessible': false,
      };

      await MockService.addFortune(fortune);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding fortune: $e');
      }
      return false;
    }
  }

  @override
  Stream<List<ContentModel>> getUserFortunesStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      final fortunes = await MockService.getFortuneHistory();
      yield fortunes.map((f) => ContentModel.fromJson(f, f['id'] as String)).toList();
    }
  }

  @override
  Future<void> setFortuneAccess(String fortuneId) async {
    await MockService.makeFortuneAccessible(fortuneId);
  }

  @override
  Future<void> markAsRead(String fortuneId) async {
    await MockService.markFortuneAsRead(fortuneId);
  }

  @override
  Future<void> deleteFortune(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    MockService.mockFortuneHistory.removeWhere((f) => f['id'] == documentId);
  }
}
