import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fortuneapp/core/config/env.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/gpt_model.dart';

part 'gpt_service.g.dart';

// OpenAI chat completion API'ını saran stateless servis.
class GptService {
  GptService({required this.apiKey, required this.model});

  final Dio dio = Dio();
  final String apiKey;
  final String model;
  final String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  // Tek bir kullanıcı mesajından chat completion alır.
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
      if (kDebugMode) print('Empty message');
      return null;
    } catch (e) {
      if (kDebugMode) print('Error fetching ${contentType.name}: $e');
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
        if (kDebugMode) print('Unexpected response structure');
      }
    } catch (e) {
      if (kDebugMode) print('error: $e');
    }
    return null;
  }
}

// GptService DI provider'ı — Env'den config inject edilir.
@Riverpod(keepAlive: true)
GptService gptService(Ref ref) =>
    GptService(apiKey: Env.gptApiKey, model: Env.gptModel);
