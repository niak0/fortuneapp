import 'package:flutter/material.dart';

abstract class NumerologyItem {
  String get displayName;
  String get description;
  Color get color;
  String get title;
  IconData get icon;
}

enum BirthDateCalculations implements NumerologyItem {
  /// Dart dilinde, eğer bir enum tanımından sonra metotlar veya getter’lar ekliyorsanız,
  /// enum değerlerinden sonra noktalı virgül koymanız gerekir.

  lifePath,
  dayOfBirth,
  attitude,
  generation; // :)

  @override
  Color get color => Colors.brown;

  @override
  String get title => "Doğum Tarihi ile Hesaplananlar";

  @override
  String get displayName {
    switch (this) {
      case BirthDateCalculations.lifePath:
        return "Yaşam Yolu";
      case BirthDateCalculations.dayOfBirth:
        return "Doğum Günü";
      case BirthDateCalculations.attitude:
        return "Tutum";
      case BirthDateCalculations.generation:
        return "Jenerasyon"; // Jenerasyon yerine Kuşak daha anlaşılır olabilir.
      default:
        return "";
    }
  }

  @override
  String get description {
    switch (this) {
      case BirthDateCalculations.lifePath:
        return "Hayat boyunca karşılaşacağınız ana temaları belirler.";
      case BirthDateCalculations.dayOfBirth:
        return "Doğduğunuz günün kişiliğinize kattığı özellikleri gösterir.";
      case BirthDateCalculations.attitude:
        return "Dış dünyaya nasıl yaklaştığınızı belirler.";
      case BirthDateCalculations.generation:
        return "Yaşadığınız dönemin size kattığı genel özellikleri temsil eder.";
    }
  }

  @override
  // TODO: implement icon
  IconData get icon => Icons.home;
}

enum NameCalculations implements NumerologyItem {
  destiny, // Kader Sayısı
  soulUrge, // Ruh Dürtüsü Sayısı
  personality, // Kişilik Sayısı
  hiddenPassion, // Gizli Tutkular Sayısı
  maturity;

  @override
  Color get color => Colors.indigo;

  @override
  String get title => "İsim ile Hesaplananlar";

  @override
  String get displayName {
    switch (this) {
      case NameCalculations.destiny:
        return "Kader";
      case NameCalculations.soulUrge:
        return "Ruh Dürtüsü";
      case NameCalculations.personality:
        return "Kişilik";
      case NameCalculations.hiddenPassion:
        return "Gizli Tutkular";
      case NameCalculations.maturity:
        return "Olgunluk";
      default:
        return "";
    }
  }

  @override
  String get description {
    switch (this) {
      case NameCalculations.destiny:
        return "Kader Sayısı, isimdeki harfler kullanılarak kişinin yaşamda üstlenmesi gereken rolü belirler.";
      case NameCalculations.soulUrge:
        return "Ruh Dürtüsü Sayısı, isimdeki sesli harflerden kişinin ruhsal arzularını analiz eder.";
      case NameCalculations.personality:
        return "Kişilik Sayısı, isimdeki sessiz harflerle dışarıdan nasıl algılandığınızı belirler.";
      case NameCalculations.hiddenPassion:
        return "Gizli Tutkular Sayısı, isimde tekrarlanan harfler kişinin derin arzularını ve tutkularını açığa çıkarır.";
      case NameCalculations.maturity:
        return "Olgunluk Sayısı, kişinin hayatındaki olgunlaşma dönemine ulaşacağı potansiyeli belirler.";
    }
  }

  @override
  // TODO: implement icon
  IconData get icon => Icons.insert_emoticon_sharp;
}

enum TimeCycles implements NumerologyItem {
  personalDay,
  personalMonth,
  personalYear;

  @override
  Color get color => Colors.purple;

  @override
  String get description {
    switch (this) {
      case TimeCycles.personalYear:
        return "Bu yılın en iyi günleri, en kötü günleri ve en iyi ve en kötü günlerin arasındaki farkı hesaplamak için kullanılır.";
      case TimeCycles.personalMonth:
        return "Bu ayın en iyi günleri, en kötü günleri ve en iyi ve en kötü günlerin arasındaki farkı hesaplamak için kullanılır.";
      case TimeCycles.personalDay:
        return "Bu günün en iyi günleri, en kötü günleri ve en iyi ve en kötü günlerin arasındaki farkı hesaplamak için kullanılır.";
      default:
        return "";
    }
  }

  @override
  String get title => "Zamana Dayalı Döngüler";

  @override
  String get displayName {
    switch (this) {
      case TimeCycles.personalYear:
        return "Yıllık";
      case TimeCycles.personalMonth:
        return "Aylık";
      case TimeCycles.personalDay:
        return "Günlük";
      default:
        return "";
    }
  }

  @override
  // TODO: implement icon
  IconData get icon => Icons.image_aspect_ratio;
}
