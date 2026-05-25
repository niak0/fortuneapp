import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/fortune_model.dart';
import '../network/mock_service.dart';

part 'fortune_repository.g.dart';

// Fal verilerine erişim için abstract interface — testte override edilebilir.
abstract class FortuneRepository {
  Stream<List<ContentModel>> watchAll();
  Future<List<ContentModel>> fetchAll();
  Future<bool> add({
    required String content,
    required String contentType,
    required String? fortuneTopic,
  });
  Future<void> setAccess(String fortuneId);
  Future<void> markAsRead(String fortuneId);
  Future<void> delete(String documentId);
}

// MockService üzerinden çalışan FortuneRepository implementasyonu.
class MockFortuneRepository implements FortuneRepository {
  @override
  Stream<List<ContentModel>> watchAll() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield await fetchAll();
    }
  }

  @override
  Future<List<ContentModel>> fetchAll() async {
    final fortunes = await MockService.getFortuneHistory();
    return fortunes
        .map((f) => ContentModel.fromJson(f, f['id'] as String))
        .toList();
  }

  @override
  Future<bool> add({
    required String content,
    required String contentType,
    required String? fortuneTopic,
  }) async {
    try {
      await MockService.addFortune({
        'id': 'fortune_${DateTime.now().millisecondsSinceEpoch}',
        'type': contentType,
        'date': DateTime.now(),
        'result': content,
        'topic': fortuneTopic,
        'isRead': false,
        'isAccessible': false,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> setAccess(String fortuneId) =>
      MockService.makeFortuneAccessible(fortuneId);

  @override
  Future<void> markAsRead(String fortuneId) =>
      MockService.markFortuneAsRead(fortuneId);

  @override
  Future<void> delete(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    MockService.mockFortuneHistory.removeWhere((f) => f['id'] == documentId);
  }
}

// FortuneRepository DI provider'ı.
@Riverpod(keepAlive: true)
FortuneRepository fortuneRepository(Ref ref) => MockFortuneRepository();
