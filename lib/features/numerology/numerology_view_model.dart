import 'package:flutter/material.dart';
import 'package:fortuneapp/features/numerology/helpers/numerology_items.dart';

class NumerologyViewModel extends ChangeNotifier {
  /// Kullanıcının tam adı.
  final String name;

  /// Kullanıcının doğum tarihi.
  final DateTime birthDate;

  /// Hesaplanmış numeroloji değerlerini tutan harita.
  final Map<NumerologyItem, int> calculatedValues = {};

  NumerologyViewModel(this.name, this.birthDate);

  /// Harflerin numerolojik değerlerini tutan sabit harita.
  static const Map<String, int> _letterValues = {
    'A': 1, 'J': 1, 'S': 1,
    'B': 2, 'K': 2, 'T': 2,
    'C': 3, 'L': 3, 'U': 3,
    'D': 4, 'M': 4, 'V': 4,
    'E': 5, 'N': 5, 'W': 5,
    'F': 6, 'O': 6, 'X': 6,
    'G': 7, 'P': 7, 'Y': 7,
    'H': 8, 'Q': 8, 'Z': 8,
    'I': 9, 'R': 9,
  };

  /// Sesli harfleri içeren sabit küme.
  static const Set<String> _vowels = {'A', 'E', 'I', 'O', 'U'};

  /// Numeroloji hesaplamalarını yapar ve sonuçları `calculatedValues` içinde saklar.
  void calculate() {
    final currentDate = DateTime.now();
    final fullName = _sanitizeName(name);

    // BirthDateCalculations
    calculatedValues[BirthDateCalculations.lifePath] = _calculateLifePathNumber(birthDate);
    calculatedValues[BirthDateCalculations.dayOfBirth] = _reduceToSingleDigit(birthDate.day);
    calculatedValues[BirthDateCalculations.attitude] = _calculateAttitudeNumber(birthDate);
    calculatedValues[BirthDateCalculations.generation] = _reduceToSingleDigit(birthDate.year);

    // NameCalculations
    calculatedValues[NameCalculations.destiny] = _calculateDestinyNumber(fullName);
    calculatedValues[NameCalculations.soulUrge] = _calculateSoulUrgeNumber(fullName);
    calculatedValues[NameCalculations.personality] = _calculatePersonalityNumber(fullName);
    calculatedValues[NameCalculations.hiddenPassion] = _calculateHiddenPassionNumber(fullName);
    calculatedValues[NameCalculations.maturity] = _calculateMaturityNumber(birthDate, fullName);

    // TimeCycles
    calculatedValues[TimeCycles.personalYear] = _calculatePersonalYearNumber(birthDate, currentDate);
    calculatedValues[TimeCycles.personalMonth] = _calculatePersonalMonthNumber(birthDate, currentDate);
    calculatedValues[TimeCycles.personalDay] = _calculatePersonalDayNumber(birthDate, currentDate);

    notifyListeners();
  }

  /// Belirli bir `NumerologyItem` için hesaplanmış değeri döndürür.
  int getValue(NumerologyItem item) => calculatedValues[item] ?? 0;

  /// Kullanıcının adını temizler ve Türkçe karakterleri dönüştürür.
  ///
  /// Örneğin, 'Ç' harfini 'C' harfine dönüştürür.
  String _sanitizeName(String name) {
    return name.toUpperCase()
        .replaceAll('Ç', 'C')
        .replaceAll('Ğ', 'G')
        .replaceAll('İ', 'I')
        .replaceAll('Ö', 'O')
        .replaceAll('Ş', 'S')
        .replaceAll('Ü', 'U')
        .replaceAll(RegExp(r'[^A-Z]'), '');
  }

  /// Bir sayıyı tek haneli bir rakama indirger.
  ///
  /// Ana sayılar (11, 22, 33) dikkate alınmaz ve tüm sayılar tek haneye indirgenir.
  int _reduceToSingleDigit(int number) {
    while (number > 9) {
      number = number.toString().split('').map(int.parse).reduce((a, b) => a + b);
    }
    return number;
  }

  /// Doğum tarihini kullanarak Yaşam Yolu Sayısını hesaplar.
  int _calculateLifePathNumber(DateTime birthDate) {
    final birthDateString = '${birthDate.day.toString().padLeft(2, '0')}${birthDate.month.toString().padLeft(2, '0')}${birthDate.year}';
    final sum = birthDateString.split('').map(int.parse).reduce((a, b) => a + b);
    return _reduceToSingleDigit(sum);
  }

  /// Doğum tarihini kullanarak Tutum Sayısını hesaplar.
  int _calculateAttitudeNumber(DateTime birthDate) {
    final sum = birthDate.day + birthDate.month;
    return _reduceToSingleDigit(sum);
  }

  /// Kullanıcının ismini kullanarak Kader Sayısını hesaplar.
  int _calculateDestinyNumber(String fullName) {
    final sum = fullName.split('').map((char) => _letterValues[char] ?? 0).reduce((a, b) => a + b);
    return _reduceToSingleDigit(sum);
  }

  /// Kullanıcının ismindeki sesli harfleri kullanarak Ruh Dürtüsü Sayısını hesaplar.
  int _calculateSoulUrgeNumber(String fullName) {
    final vowelsSum = fullName
        .split('')
        .where((char) => _vowels.contains(char))
        .map((char) => _letterValues[char] ?? 0)
        .fold(0, (a, b) => a + b);
    return _reduceToSingleDigit(vowelsSum);
  }

  /// Kullanıcının ismindeki sessiz harfleri kullanarak Kişilik Sayısını hesaplar.
  int _calculatePersonalityNumber(String fullName) {
    final consonantsSum = fullName
        .split('')
        .where((char) => !_vowels.contains(char))
        .map((char) => _letterValues[char] ?? 0)
        .fold(0, (a, b) => a + b);
    return _reduceToSingleDigit(consonantsSum);
  }

  /// Kullanıcının ismindeki en sık tekrar eden harfin numerolojik değerini bulur.
  int _calculateHiddenPassionNumber(String fullName) {
    final frequency = <int, int>{};
    for (final char in fullName.split('')) {
      final value = _letterValues[char] ?? 0;
      if (value > 0) {
        frequency[value] = (frequency[value] ?? 0) + 1;
      }
    }

    int maxFrequency = 0;
    int hiddenPassionNumber = 0;
    frequency.forEach((key, value) {
      if (value > maxFrequency) {
        maxFrequency = value;
        hiddenPassionNumber = key;
      }
    });

    return hiddenPassionNumber;
  }

  /// Yaşam Yolu ve Kader Sayılarının toplamını kullanarak Olgunluk Sayısını hesaplar.
  int _calculateMaturityNumber(DateTime birthDate, String fullName) {
    final lifePathNumber = _calculateLifePathNumber(birthDate);
    final destinyNumber = _calculateDestinyNumber(fullName);
    final sum = lifePathNumber + destinyNumber;
    return _reduceToSingleDigit(sum);
  }

  /// Doğum tarihi ve mevcut tarihi kullanarak Kişisel Yıl Sayısını hesaplar.
  int _calculatePersonalYearNumber(DateTime birthDate, DateTime currentDate) {
    final sum = _sumDigits(birthDate.day) + _sumDigits(birthDate.month) + _sumDigits(currentDate.year);
    return _reduceToSingleDigit(sum);
  }

  /// Kişisel Yıl Sayısı ve mevcut ayı kullanarak Kişisel Ay Sayısını hesaplar.
  int _calculatePersonalMonthNumber(DateTime birthDate, DateTime currentDate) {
    final personalYearNumber = _calculatePersonalYearNumber(birthDate, currentDate);
    final sum = personalYearNumber + currentDate.month;
    return _reduceToSingleDigit(sum);
  }

  /// Kişisel Ay Sayısı ve mevcut günü kullanarak Kişisel Gün Sayısını hesaplar.
  int _calculatePersonalDayNumber(DateTime birthDate, DateTime currentDate) {
    final personalMonthNumber = _calculatePersonalMonthNumber(birthDate, currentDate);
    final sum = personalMonthNumber + currentDate.day;
    return _reduceToSingleDigit(sum);
  }

  /// Bir sayının basamaklarının toplamını döndürür.
  int _sumDigits(int number) {
    return number.toString().split('').map(int.parse).reduce((a, b) => a + b);
  }
}