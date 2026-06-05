import '../../enums/gender_options.dart';
import '../../enums/relationship_status.dart';
import '../../enums/work_status.dart';
import '../../enums/zodiac_sign.dart';
import '../models/user_model.dart';

// Kullanıcı profilini GPT prompt'una çevrilebilir Türkçe bağlama dönüştürür.
// Enum '.name' değerlerini Türkçe karşılığına çözer; bilinmeyeni olduğu gibi
// bırakır (tek noktadan, dağınık firstWhere çağrılarının yerine).
String buildUserContext(UserModel user) {
  return 'İsim: ${user.name}, '
      'cinsiyet: ${_genderTr(user.gender)}, '
      'yaş: ${user.age ?? "?"}, '
      'burç: ${_zodiacTr(user.zodiacSign)}, '
      'ilişki durumu: ${_relationshipTr(user.relationshipState)}, '
      'çalışma durumu: ${_workTr(user.workState)}, '
      'şehir: ${user.location}';
}

String _genderTr(String value) {
  final option = GenderOption.values.where((e) => e.name == value).firstOrNull;
  if (option != null) return option.displayName;
  if (value == 'lgbtq') return 'LGBTQ+';
  return value;
}

String _zodiacTr(String value) =>
    ZodiacSign.values.where((e) => e.name == value).firstOrNull?.turkishName ??
    value;

String _relationshipTr(String value) =>
    RelationshipStatus.values
        .where((e) => e.name == value)
        .firstOrNull
        ?.turkishName ??
    value;

String _workTr(String value) =>
    WorkStatus.values.where((e) => e.name == value).firstOrNull?.turkishName ??
    value;
