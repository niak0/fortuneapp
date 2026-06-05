# Nâsip — Tasarım Sistemi (DESIGN.md)

Bu doküman uygulamanın görsel dilinin **tek kaynağıdır**. Yeni bir ekran/bileşen
yazarken buradaki token ve reçetelere uy; **asla hardcoded renk/px kullanma**.

Görsel referans (statik prototip): [`design/index.html`](design/index.html) +
`design/css/{tokens,base,components}.css`. Flutter karşılığı:
[`lib/core/theme/`](lib/core/theme/).

---

## 1. Felsefe — "Mistik + Modern Lüks"

- **Karanlık zemin, sıcak ışık.** Derin (neredeyse siyah) arka planlar üzerinde
  altın/alev tonları, mum ışığı hissi. Renkler eşit dağılmaz; baskın koyu zemin
  + keskin altın aksan.
- **Halo / glow.** Aksiyonlar, ikonlar ve aktif durumlar `halo` (alev rengi,
  ~%40 saydam) ile hafifçe parlar. Sert gölge yerine çok katmanlı yumuşak gölge.
- **Altın hairline'lar.** Ayraç ve kenarlıklar ince (1px), düşük opaklıkta altın
  (`line` %22 / `lineStrong` %45). Yüzeyler "patlamaz", usulca parlar.
- **Edebi tipografi.** Kazınmış başlıklar (Cinzel), zarif italik serif gövde
  başlıkları (Cormorant Garamond), temiz UI metni (Jost).
- **Yavaş ritim.** Animasyonlar incelikli ve yavaş; fısıltı gibi belirir.
- **4 tema, tek dil.** Aynı yapının 4 renk paleti — kullanıcı seçer, dil bozulmaz.

---

## 2. Temalar & Paletler

Kaynak: [`lib/core/theme/mystic_palette.dart`](lib/core/theme/mystic_palette.dart),
kimlikler: [`mystic_theme_id.dart`](lib/core/theme/mystic_theme_id.dart)
(`MysticThemeId`: candlelight / midnight / amethyst / obsidian).
Varsayılan: **Candlelight (Mum Işığı)**.

| Token | Candlelight | Midnight | Amethyst | Obsidian |
|---|---|---|---|---|
| `bgDeep` | `#120810` | `#05070F` | `#0E0814` | `#060807` |
| `bg` | `#1D0E18` | `#0A0E1D` | `#160D23` | `#0C100E` |
| `bgElev` | `#2A1622` | `#121830` | `#211433` | `#131A16` |
| `bgElev2` | `#341C2A` | `#18203F` | `#2A1A41` | `#1A241F` |
| `bgGlow` | `#4A2335` | `#1E2B55` | `#3C2459` | `#18352A` |
| `gold` | `#D8B46A` | `#C9B67E` | `#D8A7C4` | `#CBB878` |
| `goldBright` | `#F4D896` | `#EFE2AD` | `#F3CFE2` | `#EFE1A6` |
| `goldDeep` | `#9C7838` | `#7D6F48` | `#9A6F87` | `#7E7044` |
| `flame` (aksan) | `#EA8E4C` | `#6F8DFF` | `#C79BFF` | `#5DDCB0` |
| `ink` | `#F7ECDD` | `#EAF0FF` | `#F4ECFF` | `#EEF5F0` |
| `inkSoft` | `#D3B9A9` | `#AEB9D8` | `#CBB6DD` | `#AEBCB4` |
| `inkFaint` | `#97796B` | `#6A7596` | `#8A749E` | `#69776F` |

Ayrıca her palette: `line`/`lineStrong` (altın, saydam), `halo` (alev, saydam),
`star`, `onAccent`, ve semantik `danger`/`love`/`money`/`health`.

> Palette doğrudan kullanılmaz; UI'da **`MysticTokens`** ve **`ColorScheme`**
> üzerinden erişilir (aşağı bkz.). `app_theme.dart` paletten `ThemeData` +
> `ColorScheme` + `MysticTokens` üretir.

---

## 3. MysticTokens API

`ColorScheme`'in karşılamadığı mistik jetonlar:
[`lib/core/theme/mystic_tokens.dart`](lib/core/theme/mystic_tokens.dart).

**Erişim:** `final tokens = MysticTokens.of(context);`

| Alan | Kullanım |
|---|---|
| `gold` / `goldBright` / `goldDeep` | Birincil altın aksan aileleri |
| `flame` | İkincil aksan (temaya göre turuncu/mavi/mor/yeşil) |
| `ink` / `inkSoft` / `inkFaint` | Metin hiyerarşisi (birincil/ikincil/sönük) |
| `line` / `lineStrong` | İnce / belirgin altın kenarlık-ayraç |
| `halo` | Radyal glow, BoxShadow tint'i (alev, ~%40) |
| `star` | Vurgu/parıltı |
| `love` / `money` / `health` | Semantik skor/konu renkleri |
| `heroGradient` | `LinearGradient` (topRight→bottomLeft, `bgGlow`→`bg`) |

**ColorScheme eşlemesi** (renkler ayrıca buradan da gelir):
`primary=gold`, `onPrimary=onAccent`, `secondary=flame`, `surface=bg`,
`onSurface=ink`, `onSurfaceVariant=inkSoft`, `outline=lineStrong`,
`outlineVariant=line`, `surfaceContainerLow=bgElev`,
`surfaceContainerHigh=bgElev2`, `error=danger`.

---

## 4. Tipografi

Google Fonts üzerinden, [`app_theme.dart`](lib/core/theme/app_theme.dart) →
`buildTextTheme`:

| Aile | Nerede | `TextTheme` slotları |
|---|---|---|
| **Cinzel** (display, kazınmış) | App başlıkları, büyük caps | `displayLarge/Medium/Small`, `headlineLarge/Medium/Small` (letter-spacing'li) |
| **Cormorant Garamond** (zarif serif) | Kart/bölüm başlıkları, italik fısıltılar | `titleLarge`, `titleMedium` |
| **Jost** (temiz sans) | Gövde, etiket, buton | `bodyLarge/Medium/Small`, `labelLarge/Medium/Small` |

Kurallar:
- Küçük tracked caps (Cinzel) için `letterSpacing` ~2 ve `toUpperCase()`.
- İtalik serif (`titleMedium` + `fontStyle: italic` + `inkSoft`) = "mistik fısıltı".
- Renk vermek için `textTheme.X.copyWith(color: tokens.Y)`.

---

## 5. Boşluk & Köşe

[`lib/core/theme/mystic_dimens.dart`](lib/core/theme/mystic_dimens.dart):

- **`MysticSpace`**: `x1=4 · x2=8 · x3=12 · x4=16 · x5=24 · x6=32`.
- **`MysticRadius`**: `sm=12 · md=18 · lg=26 · pill=999` (+ hazır
  `smAll/mdAll/lgAll` `BorderRadius`).

Büyük dikey nefes (x5/x6) lüks hissi verir. Hardcoded px yerine bunları kullan.

---

## 6. Bileşen Reçeteleri

Hepsi token tabanlı; gerçek örnek dosyalar referans.

**Bölüm başlığı** — `SectionHeader('Başlık')`
([`core/widgets/section_header.dart`](lib/core/widgets/section_header.dart)):
altın yıldız + tracked caps + sönümlenen çizgi.

**Birincil CTA** — `MysticButton(text, icon, cost, enabled, onPressed)`
([`core/widgets/mystic_button.dart`](lib/core/widgets/mystic_button.dart)):
altın gradient pill + `halo` glow gölgesi + opsiyonel maliyet rozeti.

**Giriş animasyonu** — `MysticReveal(child, delay)`
([`core/widgets/mystic_reveal.dart`](lib/core/widgets/mystic_reveal.dart)):
fade + yukarı kayma; `delay` ile stagger.

**Hero gradient yüzey** (kart/banner):
```dart
Container(
  decoration: BoxDecoration(
    gradient: tokens.heroGradient,
    borderRadius: MysticRadius.lgAll,
    border: Border.all(color: tokens.lineStrong),
  ),
)
```

**Altın hairline kart:**
```dart
Container(
  decoration: BoxDecoration(
    color: scheme.surfaceContainerLow,        // = bgElev
    borderRadius: MysticRadius.mdAll,
    border: Border.all(color: tokens.line),
  ),
)
```

**Halo glow** (parlayan ikon/aktif durum):
```dart
boxShadow: [BoxShadow(color: tokens.halo, blurRadius: 22, spreadRadius: -8,
    offset: const Offset(0, 8))],
```

**Veil** (görsel üstü okunabilirlik) —
[`home/widgets/fortune_card.dart`](lib/features/home/widgets/fortune_card.dart):
alttan koyulaşan `LinearGradient` (`scrim` %55→%85) + üstten `RadialGradient`
(`halo`→transparent).

**Dairesel ilerleme + ikon** —
[`home/widgets/build_stream_builder.dart`](lib/features/home/widgets/build_stream_builder.dart)
`_ActiveFortuneTile`: `CircularProgressIndicator(color: flame, backgroundColor:
line)` üstüne ortalanmış `goldBright` ikon.

**Chip/rozet** —
[`my_fortunes/my_fortunes_view.dart`](lib/features/my_fortunes/my_fortunes_view.dart)
`_TopicChip`: `tokens.line` kenarlıklı küçük pill.

Örnek tam ekran: [`fortune_coffee/fortune_coffee_view.dart`](lib/features/fortune_coffee/fortune_coffee_view.dart)
(hero + section header + premium foto seçici + mistik konu kartı + CTA).

---

## 7. Kurallar (zorunlu)

1. **Hardcoded renk YOK.** Sadece `MysticTokens.of(context).*`,
   `Theme.of(context).colorScheme.*`, `textTheme.*`. Tek istisna:
   `Colors.transparent`.
2. **Hardcoded boşluk/köşe YOK.** `MysticSpace` / `MysticRadius` kullan.
3. **Private widget sınıfları** > widget döndüren helper metodlar.
4. Her class/function/view başına **Türkçe tek satır açıklama**.
5. Feature deseni: `*_view.dart` / `*_providers.dart` / `*_state.dart`.
6. Dosya adları `snake_case`; paylaşılan UI `lib/core/widgets/`.
7. Yeni renk gerekirse **palette'e** ekle (4 temaya birden), token'a bağla;
   ekranda ham `Color(0x...)` yazma.

---

## 8. Motion

- İncelikli ve yavaş; `MysticReveal` ile sıralı (stagger ~60ms) açılış.
- Seçim/aktiflik geçişleri `AnimatedContainer` (~200ms) ile yumuşak.
- Abartılı hareketten kaçın; "fısıltı" hissi korunur.

---

## 9. Dosya Haritası

```
lib/core/theme/
  mystic_palette.dart     # 4 palette (ham renkler)
  mystic_tokens.dart      # MysticTokens ThemeExtension + .of(context)
  mystic_theme_id.dart    # MysticThemeId enum (label + palette)
  mystic_dimens.dart      # MysticSpace + MysticRadius
  app_theme.dart          # palette → ThemeData/ColorScheme/TextTheme
  theme_providers.dart    # AppTheme notifier + appThemeDataProvider (runtime switch)

lib/core/widgets/         # paylaşılan UI bileşenleri
  section_header.dart      # SectionHeader
  mystic_button.dart       # MysticButton (gold gradient CTA)
  mystic_reveal.dart       # MysticReveal (giriş animasyonu)

design/                   # statik HTML/CSS prototip (görsel referans)
```

Tema değişimi: Ayarlar → tema seçici; `appThemeDataProvider` `MaterialApp`'e bağlı
olduğu için tüm token tabanlı ekranlar otomatik güncellenir.
