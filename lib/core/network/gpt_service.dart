import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fortuneapp/core/config/env.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';
import '../../core/models/gpt_model.dart';

class GptService {
  final Dio dio = Dio();
  final String _apiKey = Env.gptApiKey;
  final String _baseUrl = "https://api.openai.com/v1/chat/completions";
  final String _model = Env.gptModel;

  Future<String?> createMessage({required String message, required ContentType contentType, FortuneTopic? fortuneTopic}) async {
    ChatPost chatPost = ChatPost(
      model: _model,
      messages: [
        ///systemMessage,
        ChatMessage(
          role: "system",
          content: contentType.systemMessageContent,
        ),

        ///userMessage,
        ChatMessage(role: "user", content: message)
      ],
    );

    try {
      String? result = await sendMessage(chatPost);
      if (result != null && result.isNotEmpty) {
        return result;
      } else {
        if (kDebugMode) {
          print("Empty message");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching ${contentType.name}: $e');
      }
    }
    return null;
  }

  Future<String?> sendMessage(ChatPost chatPost) async {
    try {
      final response = await dio.post(
        _baseUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_apiKey',
          },
        ),
        data: chatPost.toJson(),
      );
      if (response.statusCode == 200) {
        final responseData = response.data;

        // Güvenli erişim ve null kontrolü
        if (responseData['choices'] != null &&
            responseData['choices'].isNotEmpty &&
            responseData['choices'][0]['message'] != null &&
            responseData['choices'][0]['message']['content'] != null) {
          String message = responseData['choices'][0]['message']['content'];
          return message;
        } else {
          if (kDebugMode) {
            print("Unexpected response structure");
          }
          return null;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("error: $e");
      }
      return null;
    }
    return null;
  }
}
