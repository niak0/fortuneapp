import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

// Kullanıcı profilini temsil eden domain modeli (Firestore: users/{uid}).
@JsonSerializable()
class UserModel {
  String name;
  DateTime birthDate;
  String location;
  String zodiacSign;

  // Cinsiyet '.name' (man/woman/lgbtq) saklanır; eski "Erkek"/"Kadın" normalize.
  @JsonKey(readValue: _readGender)
  String gender;

  String workState;

  // Eski yazım 'relationShipState' anahtarını da okur (geriye dönük uyum).
  @JsonKey(name: 'relationshipState', readValue: _readRelationship)
  String relationshipState;

  @JsonKey(defaultValue: 3)
  int coin;

  // null ise toJson'a yazılmaz → merge:true mevcut değeri ezmez.
  @JsonKey(includeIfNull: false)
  DateTime? createdAt;

  @JsonKey(includeIfNull: false)
  DateTime? updatedAt;

  UserModel({
    required this.name,
    required this.birthDate,
    required this.location,
    required this.zodiacSign,
    required this.gender,
    required this.workState,
    required this.relationshipState,
    this.coin = 3,
    this.createdAt,
    this.updatedAt,
  });

  // Yeni anahtar yoksa eski 'relationShipState' anahtarına düşer.
  static Object? _readRelationship(Map json, String key) =>
      json['relationshipState'] ?? json['relationShipState'];

  // Eski Türkçe cinsiyet değerlerini enum '.name' biçimine normalize eder.
  static Object? _readGender(Map json, String key) {
    final raw = json['gender'];
    if (raw == 'Erkek') return 'man';
    if (raw == 'Kadın') return 'woman';
    return raw;
  }

  int? get age {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  UserModel copyWith({
    String? name,
    DateTime? birthDate,
    String? location,
    String? zodiacSign,
    String? gender,
    String? workState,
    String? relationshipState,
    int? coin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      location: location ?? this.location,
      zodiacSign: zodiacSign ?? this.zodiacSign,
      gender: gender ?? this.gender,
      workState: workState ?? this.workState,
      relationshipState: relationshipState ?? this.relationshipState,
      coin: coin ?? this.coin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
