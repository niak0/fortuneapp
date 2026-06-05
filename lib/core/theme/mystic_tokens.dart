import 'package:flutter/material.dart';

import 'mystic_palette.dart';

/// `ColorScheme`'in karşılamadığı mistik tasarım jetonlarını taşıyan tema
/// uzantısı (altın aileleri, parıltı/çizgi, gradyan, semantik renkler).
///
/// View'lar `MysticTokens.of(context)` ile erişir; böylece hiçbir yerde sabit
/// renk yazılmaz ve tema değişince tüm değerler otomatik güncellenir.
@immutable
class MysticTokens extends ThemeExtension<MysticTokens> {
  const MysticTokens({
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
    required this.love,
    required this.money,
    required this.health,
    required this.heroGradient,
  });

  /// Bir [MysticPalette]'ten jetonları türetir.
  factory MysticTokens.fromPalette(MysticPalette p) {
    return MysticTokens(
      gold: p.gold,
      goldBright: p.goldBright,
      goldDeep: p.goldDeep,
      flame: p.flame,
      ink: p.ink,
      inkSoft: p.inkSoft,
      inkFaint: p.inkFaint,
      line: p.line,
      lineStrong: p.lineStrong,
      halo: p.halo,
      star: p.star,
      love: p.love,
      money: p.money,
      health: p.health,
      // CSS `linear-gradient(155deg, bgGlow, bg)` yaklaşığı.
      heroGradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [p.bgGlow, p.bg],
      ),
    );
  }

  final Color gold;
  final Color goldBright;
  final Color goldDeep;
  final Color flame;
  final Color ink;
  final Color inkSoft;
  final Color inkFaint;
  final Color line;
  final Color lineStrong;
  final Color halo;
  final Color star;
  final Color love;
  final Color money;
  final Color health;
  final LinearGradient heroGradient;

  /// Aktif temanın jetonlarına kısayol erişim.
  static MysticTokens of(BuildContext context) =>
      Theme.of(context).extension<MysticTokens>()!;

  @override
  MysticTokens copyWith({
    Color? gold,
    Color? goldBright,
    Color? goldDeep,
    Color? flame,
    Color? ink,
    Color? inkSoft,
    Color? inkFaint,
    Color? line,
    Color? lineStrong,
    Color? halo,
    Color? star,
    Color? love,
    Color? money,
    Color? health,
    LinearGradient? heroGradient,
  }) {
    return MysticTokens(
      gold: gold ?? this.gold,
      goldBright: goldBright ?? this.goldBright,
      goldDeep: goldDeep ?? this.goldDeep,
      flame: flame ?? this.flame,
      ink: ink ?? this.ink,
      inkSoft: inkSoft ?? this.inkSoft,
      inkFaint: inkFaint ?? this.inkFaint,
      line: line ?? this.line,
      lineStrong: lineStrong ?? this.lineStrong,
      halo: halo ?? this.halo,
      star: star ?? this.star,
      love: love ?? this.love,
      money: money ?? this.money,
      health: health ?? this.health,
      heroGradient: heroGradient ?? this.heroGradient,
    );
  }

  @override
  MysticTokens lerp(ThemeExtension<MysticTokens>? other, double t) {
    if (other is! MysticTokens) return this;
    return MysticTokens(
      gold: Color.lerp(gold, other.gold, t)!,
      goldBright: Color.lerp(goldBright, other.goldBright, t)!,
      goldDeep: Color.lerp(goldDeep, other.goldDeep, t)!,
      flame: Color.lerp(flame, other.flame, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkSoft: Color.lerp(inkSoft, other.inkSoft, t)!,
      inkFaint: Color.lerp(inkFaint, other.inkFaint, t)!,
      line: Color.lerp(line, other.line, t)!,
      lineStrong: Color.lerp(lineStrong, other.lineStrong, t)!,
      halo: Color.lerp(halo, other.halo, t)!,
      star: Color.lerp(star, other.star, t)!,
      love: Color.lerp(love, other.love, t)!,
      money: Color.lerp(money, other.money, t)!,
      health: Color.lerp(health, other.health, t)!,
      heroGradient:
          LinearGradient.lerp(heroGradient, other.heroGradient, t) ??
          heroGradient,
    );
  }
}
