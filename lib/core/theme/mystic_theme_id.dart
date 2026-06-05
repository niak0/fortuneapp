import 'dart:ui';

import 'mystic_palette.dart';

/// Seçilebilir mistik temalar. `design/js/data.js` `THEMES` karşılığı.
///
/// Her değer; kalıcı kimliği ([name]), kullanıcıya gösterilen Türkçe adı
/// ([label]), seçici noktasındaki rengi ([swatch]) ve renk paletini ([palette])
/// taşır. Yeni tema eklemek için buraya bir değer + [MysticPalette] eklemek
/// yeterlidir.
enum MysticThemeId {
  candlelight('Mum Işığı', MysticPalette.candlelight),
  midnight('Gece Yarısı', MysticPalette.midnight),
  amethyst('Ametist', MysticPalette.amethyst),
  obsidian('Obsidyen', MysticPalette.obsidian);

  const MysticThemeId(this.label, this.palette);

  /// Kullanıcıya gösterilen Türkçe ad.
  final String label;

  /// Bu temanın renk paleti.
  final MysticPalette palette;

  /// Tema seçicide gösterilecek temsili renk.
  Color get swatch => palette.gold;

  /// Kalıcı kimlikten ([name]) temayı çözer; bulunamazsa varsayılan döner.
  static MysticThemeId fromId(String? id) {
    return MysticThemeId.values.firstWhere(
      (t) => t.name == id,
      orElse: () => MysticThemeId.candlelight,
    );
  }
}
