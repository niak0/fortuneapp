import 'package:flutter/material.dart';

import '../home/home_view.dart';
import '../my_fortunes/my_fortunes_view.dart';

class NavigationBarViewModel with ChangeNotifier {
  int _currentIndex = 0;
  final _homeView = const HomeView();
  final _myFortunesView = const MyFortunesView();

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (index == _currentIndex) return;
    _currentIndex = index;
    notifyListeners();
  }

  List<BottomNavigationBarItem> navBarItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Anasayfa'),
    BottomNavigationBarItem(icon: Icon(Icons.notification_add_outlined), label: 'Fallarım'),
  ];

  String getAppBarTitle() => navBarItems[_currentIndex].label ?? "null";

  List<Widget> get _pages => [
        _homeView,
        _myFortunesView,
      ];
  List<Widget> get pages => _pages;
}
