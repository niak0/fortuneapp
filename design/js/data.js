/* =====================================================================
   data.js — Veri katmanı (listeleme buradan beslenir)
   ---------------------------------------------------------------------
   Listelemeyi değiştirmek için yalnızca bu diziyi düzenle. Görseller
   projedeki gerçek asset'lere işaret eder (../assets/...).
   ===================================================================== */

// Fal kategorileri — Flutter'daki HomeItemModel.homeItems karşılığı.
const FORTUNE_CATEGORIES = [
  {
    id: "coffee",
    title: "Kahve Falı",
    sub: "Telvenin fısıltısı",
    img: "../assets/icon/ic_coffee.png",
    cost: 1,
    tag: "Bugünün önerisi",
    feature: true,
  },
  {
    id: "tarot",
    title: "Tarot",
    sub: "Kartlar yol gösterir",
    img: "../assets/icon/ic_tarot.png",
    cost: 2,
  },
  {
    id: "dream",
    title: "Rüya Tabiri",
    sub: "Gecenin sırları",
    img: "../assets/icon/ic_dreams.png",
    cost: 1,
  },
  {
    id: "astrology",
    title: "Astroloji",
    sub: "Yıldızların hizası",
    img: "../assets/icon/ic_astrology.png",
    cost: 2,
  },
  {
    id: "biorhythm",
    title: "Biyoritim",
    sub: "Bedenin ritmi",
    img: "../assets/icon/ic_biorhythm.png",
    cost: 0,
  },
  {
    id: "hand",
    title: "El Falı",
    sub: "Avucundaki kader",
    img: "../assets/icon/ic_hand.png",
    cost: 1,
  },
];

// Seçilebilir temalar — tokens.css'teki [data-theme] blokları ile eşleşir.
const THEMES = [
  { id: "candlelight", name: "Mum Işığı", swatch: "#d8b46a" },
  { id: "midnight", name: "Gece Yarısı", swatch: "#6f8dff" },
  { id: "amethyst", name: "Ametist", swatch: "#c79bff" },
  { id: "obsidian", name: "Obsidyen", swatch: "#5ddcb0" },
];

// Aktif (yorumlanan) fal — ana ekrandaki canlı durum balonu.
const ACTIVE_FORTUNE = {
  kind: "Kahve Falı",
  totalSec: 1500, // 25 dk
  remainingSec: 540, // demo için kalan süre
};
