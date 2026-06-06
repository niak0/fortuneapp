import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../enums/fortune_topic.dart';
import '../../enums/gpt_content_type.dart';
import 'converters/enum_converters.dart';
import 'converters/timestamp_converter.dart';

part 'fortune_model.g.dart';

// Bir fal kaydını temsil eden domain modeli (Firestore: users/{uid}/fortunes).
@JsonSerializable(explicitToJson: true)
class FortuneModel {
  // Firestore doküman id'si; gövdeden okunmaz/yazılmaz, doc.id'den set edilir.
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? id;

  @TimestampConverter()
  DateTime? createdTime;

  @TimestampConverter()
  DateTime? unlockTime;

  String? fortune;
  String? userId;

  // Üretim durumu: 'pending' (hazırlanıyor) | 'ready' (hazır) | 'error'.
  // Eski kayıtlarda null olabilir; bu durumda fortune doluysa hazır sayılır.
  String? status;

  @ContentTypeConverter()
  ContentType? fortuneType;

  @FortuneTopicConverter()
  FortuneTopic? fortuneTopic;

  bool? isRead;
  bool? isAccessible;

  FortuneModel({
    this.id,
    this.createdTime,
    this.unlockTime,
    this.fortune,
    this.userId,
    this.status,
    this.fortuneType,
    this.fortuneTopic,
    this.isRead = false,
    this.isAccessible = false,
  });

  // Fal henüz arka planda üretiliyor.
  bool get isPending => status == 'pending';

  // Üretim başarısız oldu (altın iade edilir).
  bool get isErrored => status == 'error';

  // Hazır: status 'ready' ya da eski kayıt (status yok ama metin dolu).
  bool get isReady =>
      status == 'ready' || (status == null && (fortune?.isNotEmpty ?? false));

  factory FortuneModel.fromJson(Map<String, dynamic> json) =>
      _$FortuneModelFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneModelToJson(this);

  FortuneModel copyWith({
    String? id,
    DateTime? createdTime,
    DateTime? unlockTime,
    String? fortune,
    String? userId,
    String? status,
    ContentType? fortuneType,
    FortuneTopic? fortuneTopic,
    bool? isRead,
    bool? isAccessible,
  }) {
    return FortuneModel(
      id: id ?? this.id,
      createdTime: createdTime ?? this.createdTime,
      unlockTime: unlockTime ?? this.unlockTime,
      fortune: fortune ?? this.fortune,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      fortuneType: fortuneType ?? this.fortuneType,
      fortuneTopic: fortuneTopic ?? this.fortuneTopic,
      isRead: isRead ?? this.isRead,
      isAccessible: isAccessible ?? this.isAccessible,
    );
  }

  // Formatlanmış tarih döndüren getter.
  String get formattedDate {
    if (createdTime != null) {
      return DateFormat('dd/MM/yyyy HH:mm').format(createdTime!);
    }
    return '';
  }
}
