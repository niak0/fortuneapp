enum GenderOption { man, woman }

extension GenderOptionsExtension on GenderOption {
  String get displayName {
    switch (this) {
      case GenderOption.man:
        return "Erkek";
      case GenderOption.woman:
        return "Kadın";
      default:
        return "";
    }
  }
}
