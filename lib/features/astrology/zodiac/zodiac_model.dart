import '../../../enums/zodiac_elements.dart';
import 'zodiac_view.dart';

class ZodiacModel {
  final String sign;
  final String planet;
  final String element;
  final String dateRange;
  final int loveScore;
  final int healthScore;
  final int moneyScore;
  final String motto;
  final String commentYesterday;
  final String commentDaily;
  final String commentWeekly;
  final String commentMonthly;
  final String commentYearly;

  // Constructor
  ZodiacModel({
    required this.sign,
    required this.planet,
    required this.element,
    required this.dateRange,
    required this.loveScore,
    required this.healthScore,
    required this.moneyScore,
    required this.motto,
    required this.commentYesterday,
    required this.commentDaily,
    required this.commentWeekly,
    required this.commentMonthly,
    required this.commentYearly,
  });

  // Firestore'dan veri almak için

  int getValue(ZodiacElements element) {
    if (element == ZodiacElements.health) {
      return healthScore;
    } else if (element == ZodiacElements.love) {
      return loveScore;
    } else if (element == ZodiacElements.money) {
      return moneyScore;
    }
    return 0;
  }

  String getComment(ZodiacSegments segment) {
    switch (segment) {
      // case ZodiacSegments.yesterday:
      //   return commentYesterday;
      // case ZodiacSegments.day:
      //   return commentDaily;
      case ZodiacSegments.week:
        return commentWeekly;
      case ZodiacSegments.month:
        return commentMonthly;
      case ZodiacSegments.year:
        return commentYearly;
    }
  }
}

class DocumentSnapshot {
  final Map<String, dynamic> data;

  DocumentSnapshot({required this.data});
}
