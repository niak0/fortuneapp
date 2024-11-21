import 'package:intl/intl.dart';

class ContentModel {
  String? id;
  DateTime? createdTime;
  DateTime? unlockTime;
  String? fortune;
  String? userId;
  String? fortuneType;
  String? fortuneTopic;
  bool? isRead;
  bool? isAccessible;

  ContentModel(
      {this.id,
      this.createdTime,
      this.unlockTime,
      this.fortune,
      this.userId,
      this.fortuneType,
      this.fortuneTopic,
      this.isRead = false,
      this.isAccessible = false});

  factory ContentModel.fromJson(Map<String, dynamic> json, String id) {
    return ContentModel(
      id: id,
      createdTime: json['createdTime'],
      unlockTime: json['unlockTime'],
      fortune: json['fortune'],
      userId: json['userId'],
      fortuneType: json['fortuneType'],
      fortuneTopic: json['fortuneTopic'],
      isRead: json['isRead'],
      isAccessible: json['isAccessible'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdTime': createdTime,
      'unlockTime': unlockTime,
      'fortune': fortune,
      'userId': userId,
      'fortuneType': fortuneType,
      'fortuneTopic': fortuneTopic,
      'isRead': isRead,
      'isAccessible': isAccessible,
    };
  }

  ContentModel copyWith(
      {String? id,
      DateTime? createdTime,
      DateTime? unlockTime,
      String? fortune,
      String? userId,
      String? fortuneType,
      String? fortuneTopic,
      bool? isRead,
      bool? isAccessible}) {
    return ContentModel(
      id: id ?? this.id,
      createdTime: createdTime ?? this.createdTime,
      unlockTime: unlockTime ?? this.unlockTime,
      fortune: fortune ?? this.fortune,
      userId: userId ?? this.userId,
      fortuneType: fortuneType ?? this.fortuneType,
      fortuneTopic: fortuneTopic ?? this.fortuneTopic,
      isRead: isRead ?? this.isRead,
      isAccessible: isAccessible ?? this.isAccessible,
    );
  }

  // Formatlanmış tarih döndüren getter
  String get formattedDate {
    if (createdTime != null) {
      return DateFormat('dd/MM/yyyy HH:mm').format(createdTime!);
    }
    return '';
  }
}
