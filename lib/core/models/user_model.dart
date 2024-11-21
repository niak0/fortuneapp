class UserModel {
  String name;
  DateTime birthDate;
  String location;
  String zodiacSign;
  String gender;
  String workState;
  String relationShipState;
  int coin;

  UserModel({
    required this.name,
    required this.birthDate,
    required this.location,
    required this.zodiacSign,
    required this.gender,
    required this.workState,
    required this.relationShipState,
    this.coin = 3,
  });


  int? get age {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
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
    String? relationShipState,
    int? coin,
  }) {
    return UserModel(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      location: location ?? this.location,
      zodiacSign: zodiacSign ?? this.zodiacSign,
      gender: gender ?? this.gender,
      workState: workState ?? this.workState,
      relationShipState: relationShipState ?? this.relationShipState,
      coin: coin ?? this.coin,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      birthDate: DateTime.parse(json['birthDate']),
      location: json['location'],
      zodiacSign: json['zodiacSign'],
      gender: json['gender'],
      workState: json['workState'],
      relationShipState: json['relationShipState'],
      coin: json['coin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'location': location,
      'zodiacSign': zodiacSign,
      'gender': gender,
      'workState': workState,
      'relationShipState': relationShipState,
      'coin': coin,
    };
  }
}
