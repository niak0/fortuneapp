import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fortuneapp/features/biorhythm/helpers/day_items.dart';

class BiorhythmViewModel extends ChangeNotifier {
  final DateTime birthDate;

  DateTime currentDate = DateTime.now();

  DayItems selectedDay = DayItems.today;

  BiorhythmViewModel(this.birthDate);

  int daysBetween() {
    DateTime selectedDate = getSelectedDate();
    return selectedDate.difference(birthDate).inDays;
  }

  double calculateBiorhythm(int days, int cycle) {
    return sin((2 * pi * days) / cycle);
  }

  double decimal(int cycle) {
    // ondalık dilim hesaplama
    int daysPassed = daysBetween();
    return (1 + sin(2 * pi * daysPassed / cycle)) / 2;
  }

  int percentage(int cycle) {
    return (decimal(cycle) * 100).round();
  }

  void setSelectDay(DayItems newDay) {
    selectedDay = newDay;
    notifyListeners();
  }

  DateTime getSelectedDate() {
    switch (selectedDay) {
      case DayItems.yesterday:
        return currentDate.subtract(const Duration(days: 1)); // Dün
      case DayItems.tomorrow:
        return currentDate.add(const Duration(days: 1)); // Yarın
      case DayItems.today:
      default:
        return currentDate; // Bugün
    }
  }
}
