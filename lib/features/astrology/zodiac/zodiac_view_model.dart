import 'package:flutter/material.dart';
import '../../../core/network/mock_service.dart';
import 'zodiac_model.dart';
import 'zodiac_view.dart';

class ZodiacViewModel extends ChangeNotifier {
  List<ZodiacModel> _zodiacModels = [];
  ZodiacModel? _selectedZodiac;
  ZodiacSegments? _selectedSegment = ZodiacSegments.week;

  List<ZodiacModel> get zodiacModels => _zodiacModels;
  ZodiacModel? get selectedZodiac => _selectedZodiac;
  ZodiacSegments? get selectedSegment => _selectedSegment;

  Future<void> fetchZodiacSigns() async {
    final data = await MockService.getZodiacModels();
    _zodiacModels = data
        .map((json) => ZodiacModel(
              sign: json['sign'],
              planet: json['planet'],
              element: json['element'],
              dateRange: json['dateRange'],
              loveScore: json['loveScore'],
              healthScore: json['healthScore'],
              moneyScore: json['moneyScore'],
              motto: json['motto'],
              commentYesterday: json['commentYesterday'],
              commentDaily: json['commentDaily'],
              commentWeekly: json['commentWeekly'],
              commentMonthly: json['commentMonthly'],
              commentYearly: json['commentYearly'],
            ))
        .toList();

    _selectedZodiac = _zodiacModels.first;
    notifyListeners();
  }

  void setSelectedZodiac(ZodiacModel zodiac) {
    _selectedZodiac = zodiac;
    notifyListeners();
  }

  void setSelectedSegment(ZodiacSegments segment) {
    _selectedSegment = segment;
    notifyListeners();
  }
}
