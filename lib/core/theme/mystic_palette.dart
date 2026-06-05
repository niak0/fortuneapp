import 'package:flutter/material.dart';

/// Tek bir mistik temanın tüm ham renklerini taşıyan değişmez palet.
///
/// `design/css/tokens.css` içindeki `[data-theme]` bloklarının birebir
/// Dart karşılığıdır. Renkler burada tek kaynaktan tanımlanır; `ColorScheme`
/// ve [MysticTokens] bu paletten türetilir.
@immutable
class MysticPalette {
  const MysticPalette({
    required this.bgDeep,
    required this.bg,
    required this.bgElev,
    required this.bgElev2,
    required this.bgGlow,
    required this.gold,
    required this.goldBright,
    required this.goldDeep,
    required this.flame,
    required this.ink,
    required this.inkSoft,
    required this.inkFaint,
    required this.line,
    required this.lineStrong,
    required this.halo,
    required this.star,
    required this.onAccent,
    required this.danger,
    required this.love,
    required this.money,
    required this.health,
  });

  // Zemin katmanları (koyudan yükseltilmişe).
  final Color bgDeep;
  final Color bg;
  final Color bgElev;
  final Color bgElev2;
  final Color bgGlow;

  // Altın ailesi + vurgu (mum alevi).
  final Color gold;
  final Color goldBright;
  final Color goldDeep;
  final Color flame;

  // Metin tonları.
  final Color ink;
  final Color inkSoft;
  final Color inkFaint;

  // Çizgi/parıltı/yıldız (alfa kanallı süs renkleri).
  final Color line;
  final Color lineStrong;
  final Color halo;
  final Color star;

  // Vurgu üstü metin (koyu) ve hata.
  final Color onAccent;
  final Color danger;

  // Semantik (burç skorları vb.).
  final Color love;
  final Color money;
  final Color health;

  /// Tema 1 — Mum Işığı: sıcak altın · eflatun · amber (varsayılan).
  static const MysticPalette candlelight = MysticPalette(
    bgDeep: Color(0xFF120810),
    bg: Color(0xFF1D0E18),
    bgElev: Color(0xFF2A1622),
    bgElev2: Color(0xFF341C2A),
    bgGlow: Color(0xFF4A2335),
    gold: Color(0xFFD8B46A),
    goldBright: Color(0xFFF4D896),
    goldDeep: Color(0xFF9C7838),
    flame: Color(0xFFEA8E4C),
    ink: Color(0xFFF7ECDD),
    inkSoft: Color(0xFFD3B9A9),
    inkFaint: Color(0xFF97796B),
    line: Color(0x38D8B46A),
    lineStrong: Color(0x73D8B46A),
    halo: Color(0x66EA8E4C),
    star: Color(0xFFF4D896),
    onAccent: Color(0xFF1A0A06),
    danger: Color(0xFFEF8A7D),
    love: Color(0xFFE0796B),
    money: Color(0xFFD8B46A),
    health: Color(0xFF6FB29F),
  );

  /// Tema 2 — Gece Yarısı: derin lacivert · gümüş-altın yıldızlar.
  static const MysticPalette midnight = MysticPalette(
    bgDeep: Color(0xFF05070F),
    bg: Color(0xFF0A0E1D),
    bgElev: Color(0xFF121830),
    bgElev2: Color(0xFF18203F),
    bgGlow: Color(0xFF1E2B55),
    gold: Color(0xFFC9B67E),
    goldBright: Color(0xFFEFE2AD),
    goldDeep: Color(0xFF7D6F48),
    flame: Color(0xFF6F8DFF),
    ink: Color(0xFFEAF0FF),
    inkSoft: Color(0xFFAEB9D8),
    inkFaint: Color(0xFF6A7596),
    line: Color(0x336F8DFF),
    lineStrong: Color(0x6B6F8DFF),
    halo: Color(0x666F8DFF),
    star: Color(0xFFCDD9FF),
    onAccent: Color(0xFF050A1A),
    danger: Color(0xFFFF9D94),
    love: Color(0xFFFF8FA3),
    money: Color(0xFFC9B67E),
    health: Color(0xFF6FD0C4),
  );

  /// Tema 3 — Ametist: mor-mürdüm · gül kuvars · bakır.
  static const MysticPalette amethyst = MysticPalette(
    bgDeep: Color(0xFF0E0814),
    bg: Color(0xFF160D23),
    bgElev: Color(0xFF211433),
    bgElev2: Color(0xFF2A1A41),
    bgGlow: Color(0xFF3C2459),
    gold: Color(0xFFD8A7C4),
    goldBright: Color(0xFFF3CFE2),
    goldDeep: Color(0xFF9A6F87),
    flame: Color(0xFFC79BFF),
    ink: Color(0xFFF4ECFF),
    inkSoft: Color(0xFFCBB6DD),
    inkFaint: Color(0xFF8A749E),
    line: Color(0x38C79BFF),
    lineStrong: Color(0x75C79BFF),
    halo: Color(0x6BC79BFF),
    star: Color(0xFFF0D8FF),
    onAccent: Color(0xFF160826),
    danger: Color(0xFFF29086),
    love: Color(0xFFEF7AA6),
    money: Color(0xFFE0B25A),
    health: Color(0xFF8FCABC),
  );

  /// Tema 4 — Obsidyen: is karası · zümrüt-altın.
  static const MysticPalette obsidian = MysticPalette(
    bgDeep: Color(0xFF060807),
    bg: Color(0xFF0C100E),
    bgElev: Color(0xFF131A16),
    bgElev2: Color(0xFF1A241F),
    bgGlow: Color(0xFF18352A),
    gold: Color(0xFFCBB878),
    goldBright: Color(0xFFEFE1A6),
    goldDeep: Color(0xFF7E7044),
    flame: Color(0xFF5DDCB0),
    ink: Color(0xFFEEF5F0),
    inkSoft: Color(0xFFAEBCB4),
    inkFaint: Color(0xFF69776F),
    line: Color(0x2E5DDCB0),
    lineStrong: Color(0x665DDCB0),
    halo: Color(0x5C5DDCB0),
    star: Color(0xFFD7F3E8),
    onAccent: Color(0xFF04140E),
    danger: Color(0xFFE99488),
    love: Color(0xFFE89A86),
    money: Color(0xFFCBB878),
    health: Color(0xFF5DDCB0),
  );
}
