import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../enums/fortune_topic.dart';
import '../../enums/gpt_content_type.dart';
import '../models/fortune_model.dart';
import 'firestore_fortune_repository.dart';

part 'fortune_repository.g.dart';

// Fal verilerine erişim için abstract interface.
abstract class FortuneRepository {
  Stream<List<FortuneModel>> watchAll();
  Future<List<FortuneModel>> fetchAll();

  // Bekleyen (pending) bir fal kaydı oluşturur; GPT yorumu Cloud Function
  // tarafından arka planda üretilip kayda yazılır. [request] fal tipine özgü
  // yapısal veridir (userContext, cards, topicLabel, dreamText, images).
  Future<bool> create({
    required ContentType contentType,
    required Map<String, dynamic> request,
    FortuneTopic? fortuneTopic,
  });
  Future<void> setAccess(String fortuneId);
  Future<void> markAsRead(String fortuneId);
  Future<void> delete(String documentId);
}

// FortuneRepository DI provider'ı (production = FirestoreFortuneRepository).
@Riverpod(keepAlive: true)
FortuneRepository fortuneRepository(Ref ref) => FirestoreFortuneRepository();
