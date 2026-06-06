import 'package:fortuneapp/core/network/gpt_service.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';

// Test'lerde GptService yerine kullanılan, sabit yanıt döndüren fake.
class FakeGptService implements GptService {
  FakeGptService({this.reply = 'fal metni'});

  // null verilirse başarısız (ağ hatası) senaryosu simüle edilir.
  final String? reply;
  int callCount = 0;
  String? lastMessage;
  ContentType? lastContentType;
  List<String>? lastImages;

  @override
  Future<String?> createMessage({
    required String message,
    required ContentType contentType,
    FortuneTopic? fortuneTopic,
    List<String>? images,
  }) async {
    callCount++;
    lastMessage = message;
    lastContentType = contentType;
    lastImages = images;
    return reply;
  }
}
