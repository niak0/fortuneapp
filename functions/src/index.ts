/**
 * Nâsip Cloud Functions.
 *
 * GPT (OpenAI) çağrıları sunucu tarafında yapılır; API anahtarı Secret
 * Manager'da (`GPT_API_KEY`) tutulur ve istemciye hiç inmez.
 */

import {setGlobalOptions} from "firebase-functions";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import * as logger from "firebase-functions/logger";

setGlobalOptions({maxInstances: 10});

// OpenAI API anahtarı — `firebase functions:secrets:set GPT_API_KEY` ile set edilir.
const gptApiKey = defineSecret("GPT_API_KEY");

const openAiUrl = "https://api.openai.com/v1/chat/completions";
const defaultModel = "gpt-4o-mini";

interface GenerateFortuneData {
  system?: unknown;
  user?: unknown;
  model?: unknown;
}

// Sistem + kullanıcı mesajından fal metni üreten callable function.
export const generateFortune = onCall(
  {secrets: [gptApiKey]},
  async (request) => {
    // Anonim dahil giriş yapmış kullanıcı zorunlu (kötüye kullanımı sınırlar).
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Giriş gerekli.");
    }

    const {system, user, model} = (request.data ?? {}) as GenerateFortuneData;
    if (typeof system !== "string" || typeof user !== "string") {
      throw new HttpsError("invalid-argument", "system ve user gerekli.");
    }

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
            {role: "user", content: user},
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
