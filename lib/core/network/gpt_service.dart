import 'dart:developer' as developer;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:fortuneapp/core/config/env.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gpt_service.g.dart';

const _logName = 'gpt_service';

// Fal metni üreten servis için abstract interface (test'te fake'lenebilir).
abstract class GptService {
  Future<String?> createMessage({
    required String message,
    required ContentType contentType,
    FortuneTopic? fortuneTopic,
  });
}

// GPT çağrısını `generateFortune` Cloud Function'ı üzerinden yapar.
// API anahtarı sunucuda (Secret Manager) tutulur; istemciye hiç inmez.
class FunctionsGptService implements GptService {
  FunctionsGptService({FirebaseFunctions? functions, this.model})
    : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  // İsteğe bağlı model override (dart-define GPT_MODEL); boşsa sunucu varsayılanı.
  final String? model;

  @override
  Future<String?> createMessage({
    required String message,
    required ContentType contentType,
    FortuneTopic? fortuneTopic,
  }) async {
    try {
      final callable = _functions.httpsCallable('generateFortune');
      final result = await callable.call<Map<String, dynamic>>({
        'system': contentType.systemMessageContent,
        'user': message,
        if (model != null && model!.isNotEmpty) 'model': model,
      });
      final text = result.data['text'];
      if (text is String && text.isNotEmpty) return text;
      developer.log('Boş yanıt döndü', name: _logName, level: 900);
      return null;
    } catch (e, s) {
      developer.log(
        '${contentType.name} alınamadı',
        name: _logName,
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }
}

// GptService DI provider'ı — Cloud Function tabanlı implementasyon.
@Riverpod(keepAlive: true)
GptService gptService(Ref ref) => FunctionsGptService(model: Env.gptModel);
