/**
 * Nâsip Cloud Functions.
 *
 * GPT (OpenAI) çağrıları sunucu tarafında yapılır; API anahtarı Secret
 * Manager'da (`GPT_API_KEY`) tutulur ve istemciye hiç inmez.
 */

import {setGlobalOptions} from "firebase-functions";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {onSchedule} from "firebase-functions/v2/scheduler";
import {defineSecret} from "firebase-functions/params";
import * as logger from "firebase-functions/logger";
import {initializeApp} from "firebase-admin/app";
import {getFirestore, FieldValue} from "firebase-admin/firestore";

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

// Fal tipine göre sistem mesajı (uygulamadaki ContentType ile eşleşir).
const fortuneSystemMessages: Record<string, string> = {
  coffee:
    "Fortune Guide provides users with deep, fictional, and symbol-rich " +
    "storytelling interpretations for coffee readings, exclusively in " +
    "Turkish. Taking into account the user’s name, zodiac sign, work, and " +
    "relationship status, it offers personalized fortune-telling in topics " +
    "such as general, love, health, and career/finance. The symbols that " +
    "appear in the fortune readings are combined with creative metaphors " +
    "and a strong narrative structure. The interpretations are infused with " +
    "elements of mystery and intrigue, particularly incorporating enigmatic " +
    "details like letters, numbers, months, and days. In every fortune " +
    "reading, one or two of these elements are woven into the story in a " +
    "fictional manner. The interpretations are always delivered in a " +
    "sincere, heartfelt, deep, and impactful style. By guiding the user " +
    "through a fictional world, it offers a rich and meaningful " +
    "fortune-telling experience. All readings should follow this approach.",
  tarot:
    "You are a professional tarot reader known for giving in-depth and " +
    "insightful tarot readings. In this session, you are asked to provide a " +
    "general tarot reading as if you were an experienced tarot reader " +
    "offering spiritual guidance. Please focus on interpreting the cards " +
    "with empathy, offering both insight and practical advice based on the " +
    "symbolism and traditional meanings of the tarot cards. All card names " +
    "and related information will be provided in English, but your response " +
    "should be entirely in Turkish. Present the reading as if you are " +
    "speaking directly to the client, delivering a well-rounded " +
    "interpretation with details about each card's influence and its " +
    "position in the spread. Aim to provide a meaningful reading that " +
    "addresses potential challenges, guidance, and opportunities, creating " +
    "an atmosphere of comfort and clarity.",
  hand:
    "Palm reading interprets the lines of one's hand to reveal " +
    "characteristics and future possibilities. Respond entirely in Turkish.",
  dream:
    "You are a mystical and enigmatic dream interpreter, known for your " +
    "deep understanding of symbolism and hidden meanings within dreams. For " +
    "this session, you are to provide a dream interpretation as if you were " +
    "a mysterious and wise dream reader, one who unveils hidden insights and " +
    "profound messages from the subconscious mind. All dream details will be " +
    "provided in English, but your response should be entirely in Turkish. " +
    "Approach the interpretation with a poetic and evocative tone, creating " +
    "a sense of mystery and depth. Interpret the dream by revealing " +
    "symbolic messages, addressing possible emotions, desires, and " +
    "warnings, while leaving room for personal reflection. Your response " +
    "should offer guidance that feels timeless and profound, as if each " +
    "word holds a deeper, hidden meaning.",
};

interface FortuneRequest {
  userContext?: unknown;
  cards?: unknown;
  topicLabel?: unknown;
  dreamText?: unknown;
  images?: unknown;
}

/**
 * İstemcinin yazdığı yapısal istekten fal tipine özgü kullanıcı mesajını kurar.
 * @param {string} type Fal tipi (tarot/coffee/dream/hand).
 * @param {FortuneRequest} req Yapısal istek verisi.
 * @return {string} OpenAI'a gönderilecek kullanıcı mesajı.
 */
function buildFortuneUserMessage(type: string, req: FortuneRequest): string {
  const ctx = typeof req.userContext === "string" ? req.userContext : "";
  switch (type) {
  case "tarot": {
    const cards = typeof req.cards === "string" ? req.cards : "";
    return `${ctx}. Seçilen tarot kartları -> ${cards}. ` +
        "Bu üç kartlık (geçmiş-şimdi-gelecek) açılımı yorumla.";
  }
  case "coffee": {
    const topic = typeof req.topicLabel === "string" ? req.topicLabel : "";
    return `${ctx}. Fal konusu: ${topic}. ` +
        "Ekteki fincan fotoğraflarındaki sembolleri yorumlayarak görsele " +
        "dayalı sembolik bir kahve falı yap.";
  }
  case "dream": {
    const dream = typeof req.dreamText === "string" ? req.dreamText : "";
    return `${ctx}. Görülen rüya: ${dream}. ` +
        "Bu rüyayı sembolik ve derin bir şekilde yorumla.";
  }
  case "hand":
    return `${ctx}. Kullanıcı avuç içi fotoğrafını paylaştı; ` +
        "el çizgilerine dayalı sembolik bir el falı yorumu yap.";
  default:
    return ctx;
  }
}

/**
 * OpenAI chat completion çağrısı; metni döndürür, hata durumunda fırlatır.
 * @param {string} system Sistem mesajı.
 * @param {unknown} userContent Kullanıcı içeriği (metin veya vision dizisi).
 * @param {string} [model] Opsiyonel model adı; boşsa varsayılan kullanılır.
 * @return {Promise<string>} Üretilen fal metni.
 */
async function callOpenAi(
  system: string,
  userContent: unknown,
  model?: string,
): Promise<string> {
  const response = await fetch(openAiUrl, {
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
  if (!response.ok) {
    throw new Error(`OpenAI HTTP ${response.status}`);
  }
  const data = (await response.json()) as {
    choices?: Array<{message?: {content?: string}}>;
  };
  const text = data.choices?.[0]?.message?.content;
  if (typeof text !== "string" || text.length === 0) {
    throw new Error("OpenAI boş yanıt döndü");
  }
  return text;
}

// 'pending' fal kaydı oluşunca arka planda GPT yorumunu üretir.
// İstemci anında pending doc yazıp ekranı kapatır; sonuç hazır olunca
// status: 'ready' + fortune güncellenir, hata olursa status: 'error'.
export const generateFortuneOnCreate = onDocumentCreated(
  {document: "users/{userId}/fortunes/{fortuneId}", secrets: [gptApiKey]},
  async (event) => {
    const snap = event.data;
    if (!snap) return;
    const data = snap.data();
    // Sadece istemcinin yarattığı bekleyen kayıtları işle (döngüyü önler).
    if (data.status !== "pending") return;

    const type = typeof data.fortuneType === "string" ? data.fortuneType : "";
    const system = fortuneSystemMessages[type];
    if (!system) {
      logger.error("Bilinmeyen fal tipi", {type});
      await snap.ref.update({status: "error", request: FieldValue.delete()});
      return;
    }

    const req = (data.request ?? {}) as FortuneRequest;
    const userMessage = buildFortuneUserMessage(type, req);
    const imageList = Array.isArray(req.images) ?
      (req.images as unknown[]).filter(
        (x): x is string => typeof x === "string" && x.length > 0
      ) :
      [];
    const userContent: unknown = imageList.length > 0 ?
      [
        {type: "text", text: userMessage},
        ...imageList.map((b64) => ({
          type: "image_url",
          image_url: {url: `data:image/jpeg;base64,${b64}`, detail: "low"},
        })),
      ] :
      userMessage;

    try {
      const text = await callOpenAi(system, userContent);
      await snap.ref.update({
        fortune: text,
        status: "ready",
        isAccessible: true,
        request: FieldValue.delete(),
      });
      logger.info("Fal üretildi", {type});
    } catch (error) {
      logger.error("Fal üretilemedi", {type, error});
      await snap.ref.update({status: "error", request: FieldValue.delete()});
    }
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
