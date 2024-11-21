class CardModel {
  String? name;
  String? number;
  String? img;
  List<String>? fortuneTelling;
  List<String>? keywords;

  CardModel({
    this.name,
    this.number,
    this.img,
    this.fortuneTelling,
    this.keywords,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'img': img,
      'fortuneTelling': fortuneTelling,
      'keywords': keywords,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      name: map['name'] as String?,
      number: map['number'] as String?,
      img: map['img'] as String?,
      fortuneTelling: map['fortuneTelling'] != null ? List<String>.from(map['fortuneTelling']) : [],
      keywords: map['keywords'] != null ? List<String>.from(map['keywords']) : [],
    );
  }
}