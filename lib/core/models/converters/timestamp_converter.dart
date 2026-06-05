import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

// Firestore Timestamp <-> DateTime dönüşümünü güvenle yapan converter.
// Timestamp, ISO string ve null değerleri tolere eder (canlı veri uyumu).
class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is DateTime) return json;
    if (json is String) return DateTime.tryParse(json);
    return null;
  }

  @override
  Object? toJson(DateTime? value) =>
      value == null ? null : Timestamp.fromDate(value);
}
