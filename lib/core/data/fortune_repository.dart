import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/fortune_model.dart';
import 'firestore_fortune_repository.dart';

part 'fortune_repository.g.dart';

// Fal verilerine erişim için abstract interface.
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

// FortuneRepository DI provider'ı (production = FirestoreFortuneRepository).
@Riverpod(keepAlive: true)
FortuneRepository fortuneRepository(Ref ref) => FirestoreFortuneRepository();
