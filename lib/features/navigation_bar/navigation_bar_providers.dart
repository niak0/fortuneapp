import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../home/home_view.dart';
import '../my_fortunes/my_fortunes_view.dart';

part 'navigation_bar_providers.g.dart';

// Bottom navigation seçili sekme indeksini tutar.
@riverpod
class NavigationBarViewModel extends _$NavigationBarViewModel {
  @override
  int build() => 0;

  // Yeni indeksi yazar; aynı ise no-op.
  void setIndex(int index) {
    if (index == state) return;
    state = index;
  }
}

// Sekme tanımları (sabit).
const List<BottomNavigationBarItem> navBarItems = [
  BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Anasayfa'),
  BottomNavigationBarItem(
    icon: Icon(Icons.notification_add_outlined),
    label: 'Fallarım',
  ),
];

// Sekmelerin gösterdiği ekranlar.
const List<Widget> navBarPages = [HomeView(), MyFortunesView()];
