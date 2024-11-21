import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fortuneapp/features/astrology/chinese_zodiac/animal_enum.dart';
import 'package:provider/provider.dart';
import '../../../core/models/current_user.dart';

class ChineseZodiac extends StatelessWidget {
  const ChineseZodiac({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = context.read<CurrentUser>().currentUser!.birthDate;
    if (kDebugMode) {
      print("Birth Year: $dateTime");
    }
    AnimalEnum animal = AnimalEnum.calculateChineseZodiac(dateTime);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            Card(child: ListTile(title: const Text("Hayvan"),trailing: Text(animal.turkishName),)),
            Card(child: ListTile(title: const Text("Astral Element"),trailing: Text(animal.element),)),
            Card(child: ListTile(title: const Text("Yönetici Gezegen"),trailing: Text(animal.rulingPlanet),)),
            Card(child: ListTile(title: const Text("Uğurlu Sayılar"),trailing: Text(animal.luckyNumbers.join(', ')),)),
            Card(child: ListTile(title: const Text("Taşları"),trailing: Text(animal.luckyStones.join(', ')),)),
          ],
        ),
      ),
    );
  }
}

enum ChineseZodiacElements {
  animal("Hayvan"),
  element("Element"),
  rulingPlanet("Yönetici Gezegen"),
  luckyNumbers("Uğurlu Sayılar"),
  luckyStones("Taşları");

  final String turkishName;

  const ChineseZodiacElements(this.turkishName);
}