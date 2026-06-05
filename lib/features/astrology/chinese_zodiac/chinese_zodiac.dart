import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/features/astrology/chinese_zodiac/animal_enum.dart';
import '../../../core/auth/current_user.dart';

// Kullanıcının doğum tarihine göre Çin burcunu gösteren ekran.
class ChineseZodiac extends ConsumerWidget {
  const ChineseZodiac({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider.select((value) => value.value));
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final dateTime = user.birthDate;
    if (kDebugMode) print('Birth Year: $dateTime');
    final animal = AnimalEnum.calculateChineseZodiac(dateTime);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text("Hayvan"),
                trailing: Text(animal.turkishName),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Astral Element"),
                trailing: Text(animal.element),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Yönetici Gezegen"),
                trailing: Text(animal.rulingPlanet),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Uğurlu Sayılar"),
                trailing: Text(animal.luckyNumbers.join(', ')),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Taşları"),
                trailing: Text(animal.luckyStones.join(', ')),
              ),
            ),
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
