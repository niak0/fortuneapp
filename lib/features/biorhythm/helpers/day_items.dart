enum DayItems { yesterday, today, tomorrow }

extension DayItemsExtension on DayItems {
  String get displayName {
    switch (this) {
      case DayItems.yesterday:
        return 'Dün';
      case DayItems.today:
        return 'Bugün';
      case DayItems.tomorrow:
        return 'Yarın';
    }
  }
}
