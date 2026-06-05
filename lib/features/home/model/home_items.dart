import '../../../core/navigation/app_navigator.dart';

// Anasayfadaki fal kategorisini temsil eden değişmez model.
class HomeItemModel {
  const HomeItemModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    this.cost = 1,
    this.tag,
    this.feature = false,
  });

  final String title;

  // Karta yazılan mistik tek satırlık alt başlık.
  final String subtitle;
  final String icon;
  final AppRoutes route;

  // Falın altın maliyeti (0 → ücretsiz).
  final int cost;

  // Kartın köşesinde gösterilecek opsiyonel etiket (örn. "Bugünün önerisi").
  final String? tag;

  // true ise tam genişlik öne çıkan kart olarak render edilir.
  final bool feature;

  static const List<HomeItemModel> homeItems = [
    HomeItemModel(
      title: "Kahve Falı",
      subtitle: "Telvenin fısıltısı",
      icon: "assets/icon/ic_coffee.png",
      route: AppRoutes.fortuneCoffee,
      cost: 1,
      tag: "Bugünün önerisi",
      feature: true,
    ),
    HomeItemModel(
      title: "Tarot Falı",
      subtitle: "Kartlar yol gösterir",
      icon: "assets/icon/ic_tarot.png",
      route: AppRoutes.fortuneTarot,
      cost: 2,
    ),
    HomeItemModel(
      title: "Rüya Tabiri",
      subtitle: "Gecenin sırları",
      icon: "assets/icon/ic_dreams.png",
      route: AppRoutes.fortuneDream,
      cost: 1,
    ),
    HomeItemModel(
      title: "Astroloji",
      subtitle: "Yıldızların hizası",
      icon: "assets/icon/ic_astrology.png",
      route: AppRoutes.astrology,
      cost: 2,
    ),
    HomeItemModel(
      title: "Biyoritim",
      subtitle: "Bedenin ritmi",
      icon: "assets/icon/ic_biorhythm.png",
      route: AppRoutes.biorhythm,
      cost: 0,
    ),
  ];
}
