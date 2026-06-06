/**
 * Nâsip Cloud Functions.
 *
 * GPT (OpenAI) çağrıları sunucu tarafında yapılır; API anahtarı Secret
 * Manager'da (`GPT_API_KEY`) tutulur ve istemciye hiç inmez.
 */

import {setGlobalOptions} from "firebase-functions";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {onSchedule} from "firebase-functions/v2/scheduler";
import {defineSecret} from "firebase-functions/params";
import * as logger from "firebase-functions/logger";
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";

setGlobalOptions({maxInstances: 10});
initializeApp();

// OpenAI API anahtarı — `firebase functions:secrets:set GPT_API_KEY` ile set edilir.
const gptApiKey = defineSecret("GPT_API_KEY");

const openAiUrl = "https://api.openai.com/v1/chat/completions";
const defaultModel = "gpt-4o-mini";

// Uygulamadaki ZodiacSign enum adlarıyla bire bir eşleşmeli.
const zodiacSigns = [
  "aries", "taurus", "gemini", "cancer", "leo", "virgo",
  "libra", "scorpio", "sagittarius", "capricorn", "aquarius", "pisces",
];

interface GenerateFortuneData {
  system?: unknown;
  user?: unknown;
  model?: unknown;
  // Vision için base64 görseller (data: ön eki olmadan, ham base64).
  images?: unknown;
}

// Sistem + kullanıcı mesajından fal metni üreten callable function.
export const generateFortune = onCall(
  {secrets: [gptApiKey]},
  async (request) => {
    // Anonim dahil giriş yapmış kullanıcı zorunlu (kötüye kullanımı sınırlar).
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Giriş gerekli.");
    }

    const {system, user, model, images} =
      (request.data ?? {}) as GenerateFortuneData;
    if (typeof system !== "string" || typeof user !== "string") {
      throw new HttpsError("invalid-argument", "system ve user gerekli.");
    }

    // Geçerli base64 görselleri ayıkla; varsa vision içeriği kur, yoksa düz metin.
    const imageList = Array.isArray(images) ?
      images.filter(
        (x): x is string => typeof x === "string" && x.length > 0
      ) :
      [];
    const userContent: unknown = imageList.length > 0 ?
      [
        {type: "text", text: user},
        ...imageList.map((b64) => ({
          type: "image_url",
          image_url: {url: `data:image/jpeg;base64,${b64}`, detail: "low"},
        })),
      ] :
      user;

    let response: Response;
    try {
      response = await fetch(openAiUrl, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${gptApiKey.value()}`,
        },
        body: JSON.stringify({
          model: typeof model === "string" && model ? model : defaultModel,
          messages: [
            {role: "system", content: system},
            {role: "user", content: userContent},
          ],
        }),
      });
    } catch (error) {
      logger.error("OpenAI isteği atılamadı", {error});
      throw new HttpsError("internal", "GPT servisine ulaşılamadı.");
    }

    if (!response.ok) {
      logger.error("OpenAI hata yanıtı", {status: response.status});
      throw new HttpsError("internal", "GPT isteği başarısız.");
    }

    const data = (await response.json()) as {
      choices?: Array<{message?: {content?: string}}>;
    };
    const text = data.choices?.[0]?.message?.content;
    if (typeof text !== "string" || text.length === 0) {
      throw new HttpsError("internal", "GPT boş yanıt döndü.");
    }

    return {text};
  },
);

// Europe/Istanbul saatine göre YYYY-MM-DD tarih dizesi.
function istanbulDate(): string {
  return new Date().toLocaleDateString("en-CA", {timeZone: "Europe/Istanbul"});
}

interface DailySign {
  love: number;
  health: number;
  money: number;
  comment: string;
}

// Tek OpenAI çağrısıyla 12 burcun günlük verisini üretip Firestore'a yazar.
// Çağıran: zamanlanmış cron + manuel tetikleyici. Yazılan tarihi döndürür.
async function buildDailyHoroscopes(): Promise<string> {
  const date = istanbulDate();
  const system =
    "Sen profesyonel bir Türk astrologsun. Yalnızca geçerli JSON döndür. " +
    "Her burç için aşk/sağlık/para skorları 1-10 tam sayı ve 2-3 cümlelik " +
    "samimi, pozitif, Türkçe bir günlük yorum üret.";
  const user =
    `Bugünün tarihi ${date}. Şu 12 burcun GÜNLÜK burç yorumunu üret: ` +
    `${zodiacSigns.join(", ")}. ` +
    "Çıktı tam olarak şu şemada bir JSON nesnesi olsun: " +
    "{\"aries\":{\"love\":7,\"health\":6,\"money\":8,\"comment\":\"...\"}, " +
    "...} — anahtarlar burç adları (İngilizce), yorumlar Türkçe.";

  let response: Response;
  try {
    response = await fetch(openAiUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${gptApiKey.value()}`,
      },
      body: JSON.stringify({
        model: defaultModel,
        response_format: {type: "json_object"},
        messages: [
          {role: "system", content: system},
          {role: "user", content: user},
        ],
      }),
    });
  } catch (error) {
    logger.error("Günlük burç OpenAI isteği atılamadı", {error});
    throw new HttpsError("internal", "GPT servisine ulaşılamadı.");
  }

  if (!response.ok) {
    logger.error("Günlük burç OpenAI hata yanıtı", {status: response.status});
    throw new HttpsError("internal", "Günlük burç üretimi başarısız.");
  }

  const data = (await response.json()) as {
    choices?: Array<{message?: {content?: string}}>;
  };
  const content = data.choices?.[0]?.message?.content;
  if (typeof content !== "string" || content.length === 0) {
    throw new HttpsError("internal", "GPT boş yanıt döndü.");
  }

  const parsed = JSON.parse(content) as Record<string, Partial<DailySign>>;
  const signs: Record<string, DailySign> = {};
  const clamp = (n: unknown) =>
    Math.max(1, Math.min(10, Math.round(Number(n) || 5)));
  for (const sign of zodiacSigns) {
    const s = parsed[sign];
    if (!s || typeof s.comment !== "string") {
      throw new HttpsError("internal", `Eksik burç verisi: ${sign}`);
    }
    signs[sign] = {
      love: clamp(s.love),
      health: clamp(s.health),
      money: clamp(s.money),
      comment: s.comment,
    };
  }

  await getFirestore()
    .collection("dailyHoroscopes")
    .doc("current")
    .set({date, signs, updatedAt: new Date().toISOString()});

  logger.info("Günlük burçlar yazıldı", {date});
  return date;
}

// Her gün 00:05 (Europe/Istanbul) 12 burcu üretir.
export const generateDailyHoroscopes = onSchedule(
  {schedule: "5 0 * * *", timeZone: "Europe/Istanbul", secrets: [gptApiKey]},
  async () => {
    await buildDailyHoroscopes();
  },
);

// Manuel tetikleyici (test/ilk dolum için) — cron'u beklemeden çalıştırır.
export const generateDailyHoroscopesNow = onCall(
  {secrets: [gptApiKey]},
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Giriş gerekli.");
    }
    const date = await buildDailyHoroscopes();
    return {ok: true, date};
  },
);
