import 'package:flutter/material.dart';
import 'zodiac/zodiac_view.dart';
import 'chinese_zodiac/chinese_zodiac.dart';

class AstrologyView extends StatefulWidget {
  const AstrologyView({super.key});

  @override
  State<AstrologyView> createState() => _AstrologyViewState();
}

class _AstrologyViewState extends State<AstrologyView> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Astroloji"),
          bottom: TabBar(
            onTap: (index) => _onTabTapped(index),
            tabs: const [
              Tab(text: "Burçlar"),
              Tab(text: "Çin Burcun"),
            ],
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            ZodiacView(),
            ChineseZodiac(),
          ],
        ),
      ),
    );
  }
}
