import 'dart:math';

import 'package:fortuneapp/features/biorhythm/helpers/day_items.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biorhythm_view_model.g.dart';

// Seçili gün (dün/bugün/yarın) için biyoritim hesaplaması yapar.
@riverpod
class BiorhythmViewModel extends _$BiorhythmViewModel {
  late final DateTime _birthDate;

  @override
  DayItems build({required DateTime birthDate}) {
    _birthDate = birthDate;
    return DayItems.today;
  }

  // Seçili güne kadar geçen gün sayısı.
  int daysBetween() {
    final selectedDate = getSelectedDate();
    return selectedDate.difference(_birthDate).inDays;
  }

  // Bir döngü için sinüs değeri.
  double calculateBiorhythm(int days, int cycle) =>
      sin((2 * pi * days) / cycle);

  // 0-1 arası ondalık dilim.
  double decimal(int cycle) {
    final daysPassed = daysBetween();
    return (1 + sin(2 * pi * daysPassed / cycle)) / 2;
  }

  // 0-100 arası yüzde.
  int percentage(int cycle) => (decimal(cycle) * 100).round();

  // Seçili günü değiştirir.
  void setSelectDay(DayItems newDay) {
    if (newDay == state) return;
    state = newDay;
  }

  // Mevcut seçime göre tarihi döner.
  DateTime getSelectedDate() {
    final now = DateTime.now();
    switch (state) {
      case DayItems.yesterday:
        return now.subtract(const Duration(days: 1));
      case DayItems.tomorrow:
        return now.add(const Duration(days: 1));
      case DayItems.today:
        return now;
    }
  }
}
