/* =====================================================================
   app.js — Görünüm katmanı: atmosfer, listeleme, tema motoru, etkileşim
   ===================================================================== */

// İnce çizgili (stroke) SVG ikon kütüphanesi — bağımlılıksız ve net.
const ICONS = {
  moon: '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.4"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"/></svg>',
  coin: '<svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="9"/><path d="M12 7v10M9.5 9.2c0-1 1.1-1.7 2.5-1.7s2.5.6 2.5 1.6-1 1.5-2.5 1.5-2.5.6-2.5 1.6 1.1 1.7 2.5 1.7 2.5-.7 2.5-1.7"/></svg>',
  user: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.4"><circle cx="12" cy="8" r="3.5"/><path d="M5 20c0-3.6 3.1-6 7-6s7 2.4 7 6"/></svg>',
  spark: '<svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l1.6 6.8L20 12l-6.4 3.2L12 22l-1.6-6.8L4 12l6.4-3.2z"/></svg>',
  bolt: '<svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M13 2L4 14h6l-1 8 9-12h-6z"/></svg>',
  cup: '<svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.4"><path d="M5 9h11v4a5 5 0 0 1-5 5H10a5 5 0 0 1-5-5z"/><path d="M16 10h2.5a2.5 2.5 0 0 1 0 5H16"/><path d="M8 5.5c0-.8.6-1.2.6-2M11 5.5c0-.8.6-1.2.6-2" stroke-linecap="round"/></svg>',
  home: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M4 11l8-7 8 7v8a1 1 0 0 1-1 1h-4v-6h-6v6H5a1 1 0 0 1-1-1z"/></svg>',
  scroll: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M6 4h10a2 2 0 0 1 2 2v12a2 2 0 0 0 2 2H8a2 2 0 0 1-2-2z"/><path d="M9 8h6M9 12h6"/></svg>',
  store: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M4 9l1-4h14l1 4M5 9v9a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V9M4 9h16"/></svg>',
  profile: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="8" r="3.2"/><path d="M5.5 20c0-3.4 2.9-5.5 6.5-5.5s6.5 2.1 6.5 5.5"/></svg>',
  star4: '<svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2c.4 4.6 1.4 8 8 10-6.6 2-7.6 5.4-8 10-.4-4.6-1.4-8-8-10 6.6-2 7.6-5.4 8-10z"/></svg>',
  apple: '<svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M16 1.8c.1 1-.3 2-1 2.8-.7.8-1.8 1.4-2.8 1.3-.1-1 .4-2 1-2.7.7-.8 1.9-1.3 2.8-1.4zM19 17c-.5 1.1-.7 1.6-1.3 2.6-.9 1.4-2.1 3.1-3.6 3.1-1.4 0-1.7-.9-3.6-.9s-2.3.9-3.6.9c-1.5 0-2.7-1.6-3.5-2.9C1.2 16.4.9 12 2.3 9.6 3.3 8 4.9 7 6.4 7c1.5 0 2.5 1 3.7 1 1.2 0 1.9-1 3.7-1 1.3 0 2.7.7 3.7 2-3.2 1.8-2.7 6.4 1.5 8z"/></svg>',
  google: '<svg width="18" height="18" viewBox="0 0 24 24"><path fill="#EA4335" d="M12 10.2v3.9h5.4c-.2 1.4-1.6 4.1-5.4 4.1-3.3 0-5.9-2.7-5.9-6s2.6-6 5.9-6c1.9 0 3.1.8 3.8 1.5l2.6-2.5C16.7 1.6 14.6.6 12 .6 6.8.6 2.6 4.8 2.6 10s4.2 9.4 9.4 9.4c5.4 0 9-3.8 9-9.2 0-.6 0-1.1-.2-1.6z"/></svg>',
};

const $ = (sel) => document.querySelector(sel);
const el = (tag, cls, html) => {
  const n = document.createElement(tag);
  if (cls) n.className = cls;
  if (html != null) n.innerHTML = html;
  return n;
};

/* ---------- Atmosfer: yıldız alanı ---------- */
function seedStars(count) {
  const layer = $(".stars");
  // Deterministik dağılım — Math.random yerine altın oranlı serpiştirme.
  for (let i = 0; i < count; i++) {
    const s = el("span", "star");
    const t = (i * 0.61803398875) % 1;
    const t2 = (i * 0.7548776662) % 1;
    const size = 1 + ((i * 7) % 3) * 0.7;
    s.style.left = `${t * 100}%`;
    s.style.top = `${t2 * 92}%`;
    s.style.width = `${size}px`;
    s.style.height = `${size}px`;
    s.style.setProperty("--dur", `${3 + (i % 5)}s`);
    s.style.setProperty("--delay", `${(i % 9) * 0.4}s`);
    s.style.setProperty("--peak", `${0.4 + ((i % 4) * 0.18)}`);
    layer.appendChild(s);
  }
}

/* ---------- Listeleme: kategori kartları ---------- */
function renderGrid() {
  const grid = $("#grid");
  FORTUNE_CATEGORIES.forEach((c, i) => {
    const card = el("button", c.feature ? "card card--feature" : "card");
    card.style.setProperty("--rd", `${0.15 + i * 0.06}s`);
    card.setAttribute("data-reveal", "");

    const costHtml =
      c.cost === 0
        ? `<span class="card__cost card__cost--free">Ücretsiz</span>`
        : `<span class="card__cost">${ICONS.coin}${c.cost}</span>`;

    card.innerHTML = `
      <img class="card__img" src="${c.img}" alt="${c.title}" loading="lazy" />
      <span class="card__veil"></span>
      <span class="card__frame"></span>
      ${c.tag ? `<span class="card__tag">${c.tag}</span>` : ""}
      <span class="card__content">
        <span>
          <span class="card__title">${c.title}</span>
          <span class="card__sub">${c.sub}</span>
        </span>
        ${costHtml}
      </span>`;
    grid.appendChild(card);
  });
}

/* ---------- Aktif fal: dairesel geri sayım ---------- */
let countdownTimer = null;
function renderActive() {
  const R = 32;
  const C = 2 * Math.PI * R;
  $("#ringTrack").setAttribute("stroke-dasharray", C);
  $("#ringFill").setAttribute("stroke-dasharray", C);

  let remaining = ACTIVE_FORTUNE.remainingSec;
  const tick = () => {
    const pct = 1 - remaining / ACTIVE_FORTUNE.totalSec;
    $("#ringFill").setAttribute("stroke-dashoffset", C * (1 - pct));
    const m = Math.floor(remaining / 60);
    $("#activeSub").textContent =
      remaining > 0 ? `Yaklaşık ${m + 1} dk · telve okunuyor` : "Falın hazır ✦";
    if (remaining > 0) remaining -= 1;
    else {
      $("#activeEyebrow").textContent = "HAZIR";
      $("#activeTitle").textContent = "Falın seni bekliyor";
      clearInterval(countdownTimer);
    }
  };
  tick();
  countdownTimer = setInterval(tick, 1000);
}

/* ---------- Tema motoru ---------- */
function renderThemeSwitch() {
  const wrap = $("#themeSwitch");
  THEMES.forEach((t) => {
    const dot = el("button", "theme-dot");
    dot.style.background = t.swatch;
    dot.style.color = t.swatch;
    dot.title = t.name;
    dot.dataset.theme = t.id;
    dot.addEventListener("click", () => setTheme(t.id));
    wrap.appendChild(dot);
  });
}

function setTheme(id) {
  document.documentElement.setAttribute("data-theme", id);
  document.querySelectorAll(".theme-dot").forEach((d) =>
    d.classList.toggle("is-active", d.dataset.theme === id)
  );
}

/* ---------- Giriş alt sayfası ---------- */
function bindSheet() {
  const open = () => {
    $("#sheet").classList.add("is-open");
    $("#scrim").classList.add("is-open");
  };
  const close = () => {
    $("#sheet").classList.remove("is-open");
    $("#scrim").classList.remove("is-open");
  };
  $("#notice").addEventListener("click", open);
  $("#scrim").addEventListener("click", close);
}

/* ---------- Alt navigasyon ---------- */
function bindNav() {
  document.querySelectorAll(".nav__btn").forEach((b) => {
    b.addEventListener("click", () => {
      document.querySelectorAll(".nav__btn").forEach((x) =>
        x.classList.remove("is-active")
      );
      b.classList.add("is-active");
    });
  });
}

/* ---------- Statik ikonları yerleştir ---------- */
function paintIcons() {
  $("#brandMark").innerHTML = ICONS.star4;
  $("#coinIcon").innerHTML = ICONS.coin;
  $("#avatarIcon").innerHTML = ICONS.user;
  $("#noticeIcon").innerHTML = ICONS.moon;
  $("#noticeCta").innerHTML = ICONS.spark;
  $("#cupIcon").innerHTML = ICONS.cup;
  $("#accelIcon").innerHTML = ICONS.bolt;
  $("#headStar").innerHTML = ICONS.star4;
  $("#navHome").innerHTML = ICONS.home;
  $("#navScroll").innerHTML = ICONS.scroll;
  $("#navStore").innerHTML = ICONS.store;
  $("#navProfile").innerHTML = ICONS.profile;
  $("#appleIcon").innerHTML = ICONS.apple;
  $("#googleIcon").innerHTML = ICONS.google;
}

/* ---------- Başlat ---------- */
function init() {
  setTheme("candlelight");
  paintIcons();
  seedStars(46);
  renderThemeSwitch();
  setTheme("candlelight");
  renderActive();
  renderGrid();
  bindSheet();
  bindNav();
}

document.addEventListener("DOMContentLoaded", init);
