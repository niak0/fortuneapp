import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:fortuneapp/core/config/env.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/gpt_model.dart';

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

// OpenAI chat completion API'ını saran stateless servis.
class OpenAiGptService implements GptService {
  OpenAiGptService({required this.apiKey, required this.model, Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 60),
            ),
          );

  final Dio dio;
  final String apiKey;
  final String model;
  final String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  // Tek bir kullanıcı mesajından chat completion alır.
  @override
  Future<String?> createMessage({
    required String message,
    required ContentType contentType,
    FortuneTopic? fortuneTopic,
  }) async {
    final chatPost = ChatPost(
      model: model,
      messages: [
        ChatMessage(role: 'system', content: contentType.systemMessageContent),
        ChatMessage(role: 'user', content: message),
      ],
    );

    try {
      final result = await sendMessage(chatPost);
      if (result != null && result.isNotEmpty) return result;
      developer.log('Boş mesaj döndü', name: _logName, level: 900);
      return null;
    } catch (e, s) {
      developer.log(
        '${contentType.name} alınamadı',
        name: _logName,
        error: e,
        stackTrace: s,
      );
    }
    return null;
  }

  // Hazırlanmış ChatPost'u API'ya gönderir.
  Future<String?> sendMessage(ChatPost chatPost) async {
    try {
      final response = await dio.post(
        _baseUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
        ),
        data: chatPost.toJson(),
      );
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['choices'] != null &&
            responseData['choices'].isNotEmpty &&
            responseData['choices'][0]['message'] != null &&
            responseData['choices'][0]['message']['content'] != null) {
          return responseData['choices'][0]['message']['content'] as String;
        }
        developer.log('Beklenmeyen yanıt yapısı', name: _logName, level: 900);
      }
    } catch (e, s) {
      developer.log(
        'sendMessage HATA',
        name: _logName,
        error: e,
        stackTrace: s,
      );
    }
    return null;
  }
}

// GptService DI provider'ı — Env'den config inject edilir.
@Riverpod(keepAlive: true)
GptService gptService(Ref ref) =>
    OpenAiGptService(apiKey: Env.gptApiKey, model: Env.gptModel);
