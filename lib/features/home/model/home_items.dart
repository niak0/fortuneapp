import 'package:flutter/material.dart';
import '../../../core/navigation/app_navigator.dart';

class HomeItemModel {
  final String title;
  final String icon;
  final AppRoutes route;

  HomeItemModel({
    required this.title,
    required this.icon,
    required this.route,
  });

  GridTile get tile {
    return GridTile(
      footer: GridTileBar(
        subtitle: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.black54,
      ),
      child: Image.asset(
        icon,
        fit: BoxFit.cover,
      ),
    );
  }

  static final List<HomeItemModel> homeItems = [
    HomeItemModel(
      title: "Kahve Falı",
      icon: "assets/icon/ic_coffee.png",
      route: AppRoutes.fortuneCoffee,
    ),
    // HomeItemModel(
    //   title: "El Falı",
    //   icon: "assets/icon/ic_hand.png",
    //   route: AppRoutes.fortuneHand,
    // ),
    HomeItemModel(
      title: "Tarot Falı",
      icon: "assets/icon/ic_tarot.png",
      route: AppRoutes.fortuneTarot,
    ),
    HomeItemModel(
      title: "Rüya Tabiri",
      icon: "assets/icon/ic_dreams.png",
      route: AppRoutes.fortuneDream,
    ),
    HomeItemModel(
      title: "Astroloji",
      icon: "assets/icon/ic_astrology.png",
      route: AppRoutes.astrology,
    ),
    HomeItemModel(
      title: "Biyoritim",
      icon: "assets/icon/ic_biorhythm.png",
      route: AppRoutes.biorhythm,
    ),
    // HomeItemModel(
    //   title: "Numeroloji",
    //   icon: "assets/icon/ic_numerology.png",
    //   route: AppRoutes.numerology,
    // ),
  ];
}