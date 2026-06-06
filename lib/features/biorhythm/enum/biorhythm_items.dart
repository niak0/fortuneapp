import 'package:flutter/material.dart';
import 'package:fortuneapp/core/theme/mystic_tokens.dart';

// Biyoritim döngüleri: 3 birincil (fiziksel/duygusal/zihinsel) + 3 ikincil.
enum BiorhythmItems {
  physical("Fiziksel"),
  emotional("Duygusal"),
  intellectual("Zihinsel"),
  intuition("Sezgisel"),
  aesthetic("Estetik"),
  spiritual("Ruhsal");

  final String name;
  const BiorhythmItems(this.name);
}

// Yorum fazları: her %10 için bir dilim (d0..d9) + sıfır geçişinde kritik gün.
enum _BioPhase { d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, critical }

extension BiorhythmItemsExtension on BiorhythmItems {
  // Her döngüyü aktif temanın semantik rengine eşler.
  Color color(MysticTokens tokens) {
    switch (this) {
      case BiorhythmItems.physical:
        return tokens.health;
      case BiorhythmItems.emotional:
        return tokens.love;
      case BiorhythmItems.intellectual:
        return tokens.flame;
      case BiorhythmItems.intuition:
        return tokens.star;
      case BiorhythmItems.aesthetic:
        return tokens.gold;
      case BiorhythmItems.spiritual:
        return tokens.halo;
    }
  }

  IconData get icon {
    switch (this) {
      case BiorhythmItems.physical:
        return Icons.emoji_people_outlined;
      case BiorhythmItems.emotional:
        return Icons.emoji_emotions_outlined;
      case BiorhythmItems.intellectual:
        return Icons.interests_outlined;
      case BiorhythmItems.intuition:
        return Icons.auto_awesome_outlined;
      case BiorhythmItems.aesthetic:
        return Icons.palette_outlined;
      case BiorhythmItems.spiritual:
        return Icons.self_improvement_outlined;
    }
  }

  // Klasik biyoritim döngü uzunlukları (gün).
  int get cycle {
    switch (this) {
      case BiorhythmItems.physical:
        return 23;
      case BiorhythmItems.emotional:
        return 28;
      case BiorhythmItems.intellectual:
        return 33;
      case BiorhythmItems.intuition:
        return 38;
      case BiorhythmItems.aesthetic:
        return 43;
      case BiorhythmItems.spiritual:
        return 53;
    }
  }

  // Yüzde (0-100) + kritik bilgisinden %10'luk dilimi seçer.
  _BioPhase _phase(int percentage, bool isCritical) {
    if (isCritical) return _BioPhase.critical;
    if (percentage <= 10) return _BioPhase.d0;
    if (percentage <= 20) return _BioPhase.d1;
    if (percentage <= 30) return _BioPhase.d2;
    if (percentage <= 40) return _BioPhase.d3;
    if (percentage <= 50) return _BioPhase.d4;
    if (percentage <= 60) return _BioPhase.d5;
    if (percentage <= 70) return _BioPhase.d6;
    if (percentage <= 80) return _BioPhase.d7;
    if (percentage <= 90) return _BioPhase.d8;
    return _BioPhase.d9;
  }

  // Seçili güne ait yüzde ve kritik bilgisine göre zengin Türkçe yorum.
  String getComment(int percentage, {bool isCritical = false}) {
    return _comments[this]![_phase(percentage, isCritical)]!;
  }
}

// Döngü × dilim (%10) bazlı yorum metinleri (kritik gün dahil).
const Map<BiorhythmItems, Map<_BioPhase, String>> _comments = {
  BiorhythmItems.physical: {
    _BioPhase.d0:
        'Fiziksel enerjin dibe vurmuş; bedenin tam dinlenme istiyor. Bugünü '
        'kendine ayır, ağır her şeyi ertele.',
    _BioPhase.d1:
        'Enerjin çok düşük, çabuk yoruluyorsun. Bol uyku, su ve hafif '
        'beslenmeyle toparlanmaya odaklan.',
    _BioPhase.d2:
        'Bedenin yavaşça canlanıyor ama hâlâ kırılgan. Kısa, hafif yürüyüşler '
        'iyi gelir; kendini zorlama.',
    _BioPhase.d3:
        'Toparlanma sürecindesin, enerji geri geliyor. Orta tempolu işler '
        'yapabilirsin, sınırını koru.',
    _BioPhase.d4:
        'Fiziksel durumun ortalamaya yaklaşıyor. Günlük rutinini rahat '
        'yürütürsün, dengeli kal.',
    _BioPhase.d5:
        'Enerjin ortanın üstünde, kendini fena hissetmiyorsun. Düzenli '
        'hareketle bu ivmeyi büyüt.',
    _BioPhase.d6:
        'Bedenin iyi durumda ve dinç. Spor ve aktif uğraşlardan keyif '
        'alacağın verimli bir gün.',
    _BioPhase.d7:
        'Fiziksel performansın yüksek. Daha zorlu antrenman ve aktiviteler '
        'için motivasyonun tam.',
    _BioPhase.d8:
        'Enerjin çok yüksek, kendini güçlü hissediyorsun. Büyük fiziksel '
        'hedeflere yüklenmenin tam zamanı.',
    _BioPhase.d9:
        'Fiziksel olarak zirvedesin; dayanıklılığın tavanda. Enerjini '
        'değerlendir ama aşırıya kaçma.',
    _BioPhase.critical:
        'Fiziksel ritmin bugün kritik geçiş gününde — bedenin dengesiz '
        'olabilir. Riskli ve zorlayıcı işleri ertele, temkinli ol.',
  },
  BiorhythmItems.emotional: {
    _BioPhase.d0:
        'Duyguların en hassas noktada; her şey büyük gelebilir. Kendine '
        'şefkat göster, sakin bir köşeye çekil.',
    _BioPhase.d1:
        'Moralin düşük ve kırılgansın. Sevdiklerinin desteği ve nazik bir '
        'ortam iyi gelecek.',
    _BioPhase.d2:
        'Duygusal dalgalanmalar azalıyor ama hâlâ değişkensin. Hislerini '
        'paylaşmak rahatlatır.',
    _BioPhase.d3:
        'Ruh halin yavaşça düzeliyor. Küçük keyifler ve hobiler moralini '
        'yukarı taşır.',
    _BioPhase.d4:
        'Duygusal dengeye yaklaşıyorsun. Sosyal temas ve içten sohbetler '
        'bugün iyi gelir.',
    _BioPhase.d5:
        'Moralin ortanın üstünde, daha istikrarlısın. İlişkilerine zaman '
        'ayırmak için uygun bir gün.',
    _BioPhase.d6:
        'Duygusal enerjin iyi; empatin açık. Bağlarını derinleştirmek için '
        'verimli bir gün.',
    _BioPhase.d7:
        'Moralin yüksek, çevrene olumlu yansıyorsun. Yeni dostluklar ve '
        'paylaşımlar için harika.',
    _BioPhase.d8:
        'Duygusal enerjin çok yüksek; sevgi ve coşku dolusun. Bu havayı '
        'sevdiklerinle paylaş.',
    _BioPhase.d9:
        'Duygusal olarak zirvedesin; içten bir mutluluk yayıyorsun. '
        'İlişkilerinde derinleşmenin tam zamanı.',
    _BioPhase.critical:
        'Duygusal ritmin kritik gününde — ani ruh hali değişimleri olabilir. '
        'Önemli kararları ve tartışmaları bugün erteleyebilirsin.',
  },
  BiorhythmItems.intellectual: {
    _BioPhase.d0:
        'Zihinsel enerjin dipte; odaklanmak çok zor. Karmaşık işleri bırak, '
        'beynine tam mola ver.',
    _BioPhase.d1:
        'Konsantrasyonun çok düşük, dikkatin dağınık. Basit ve rutin işlerle '
        'günü geçir.',
    _BioPhase.d2:
        'Zihnin yavaş açılıyor. Kısa odak blokları ve notlarla küçük işleri '
        'toparlayabilirsin.',
    _BioPhase.d3:
        'Berraklık geri geliyor. Planlama ve hafif analitik işler için uygun '
        'bir aralık.',
    _BioPhase.d4:
        'Zihinsel durumun ortalamaya yakın. Günlük kararları rahat alır, '
        'organize olursun.',
    _BioPhase.d5:
        'Odak ve kavrayışın ortanın üstünde. Yeni bilgi öğrenmek için iyi bir '
        'gün.',
    _BioPhase.d6:
        'Zihnin keskin; analiz ve problem çözme akıcı. Önemli işlere '
        'girebilirsin.',
    _BioPhase.d7:
        'Zihinsel performansın yüksek. Stratejik kararlar ve yaratıcı '
        'çözümler için verimli.',
    _BioPhase.d8:
        'Kavrayışın çok yüksek; zor konuları kolayca çözüyorsun. Büyük '
        'projelere odaklan.',
    _BioPhase.d9:
        'Zihinsel olarak zirvedesin; zekân ve yaratıcılığın tavanda. En çetin '
        'işlere şimdi gir.',
    _BioPhase.critical:
        'Zihinsel ritmin kritik gününde — dikkat dağınıklığı ve hatalar '
        'olası. Önemli kararları ve detayları iki kez kontrol et.',
  },
  BiorhythmItems.intuition: {
    _BioPhase.d0:
        'Sezgilerin tamamen sönük; içsesin susmuş. Kararları kesinlikle somut '
        'verilere bırak.',
    _BioPhase.d1:
        'Önsezilerin çok zayıf, yanıltıcı olabilir. İçgüdüsel hamlelerden '
        'kaçın.',
    _BioPhase.d2:
        'Sezgisel algın düşük. Acele etme, gözlem yaparak ilerle.',
    _BioPhase.d3:
        'İçsesin yavaş netleşiyor. İçgüdülerini mantıkla teyit ederek kullan.',
    _BioPhase.d4:
        'Sezgilerin ortalamaya yaklaşıyor. Hislerine kulak ver ama tek başına '
        'güvenme.',
    _BioPhase.d5:
        'Sezgilerin ortanın üstünde, daha isabetli. Küçük seziş anlarına '
        'dikkat et.',
    _BioPhase.d6:
        'İçgüdülerin iyi çalışıyor. Zamanlama ve insan okuma konusunda bugün '
        'şanslısın.',
    _BioPhase.d7:
        'Sezgilerin güçlü ve doğru. İlk hislerine güvenmek genelde işe '
        'yarayacak.',
    _BioPhase.d8:
        'Önsezilerin çok keskin; fırsatları önceden hissediyorsun. İçsesini '
        'ciddiye al.',
    _BioPhase.d9:
        'Sezgisel olarak zirvedesin; ilk hislerin neredeyse hep doğru. '
        'İçgüdüne güvenle hareket et.',
    _BioPhase.critical:
        'Sezgisel ritmin kritik gününde — içgüdülerin yanıltıcı olabilir. '
        'Bugün önsezilere değil somut bilgiye dayan.',
  },
  BiorhythmItems.aesthetic: {
    _BioPhase.d0:
        'Yaratıcı kıvılcımın tükenmiş; ilham yok. Üretmeye çalışma, dinlen ve '
        'basit zevklere sığın.',
    _BioPhase.d1:
        'Estetik algın çok düşük. Yeni iş yerine var olanı sadeleştirmek daha '
        'iyi.',
    _BioPhase.d2:
        'Yaratıcılığın yavaş canlanıyor. Küçük düzenlemeler ve toparlama '
        'işleri uygun.',
    _BioPhase.d3:
        'İlham geri geliyor. Hafif yaratıcı dokunuşlar ve düzenlemeler '
        'yapabilirsin.',
    _BioPhase.d4:
        'Estetik duyun ortalamaya yakın. Ortamını güzelleştirecek küçük işler '
        'iyi gider.',
    _BioPhase.d5:
        'Yaratıcı enerjin ortanın üstünde. Müzik, sanat ve tasarımla '
        'ilgilenmek keyif verir.',
    _BioPhase.d6:
        'Estetik algın iyi; güzeli kolay yakalıyorsun. Tasarım ve ifade için '
        'verimli bir gün.',
    _BioPhase.d7:
        'Yaratıcılığın yüksek. Sanatsal projeler ve görsel kararlar için '
        'motivasyonun tam.',
    _BioPhase.d8:
        'İlhamın çok güçlü; fikirler akıyor. Yaratıcı işlere ve estetik '
        'seçimlere yüklen.',
    _BioPhase.d9:
        'Estetik olarak zirvedesin; ilham seni buluyor. Büyük yaratıcı işler '
        'için mükemmel zaman.',
    _BioPhase.critical:
        'Estetik ritmin kritik gününde — zevk ve uyum algın dengesiz olabilir. '
        'Önemli görsel/tasarım kararlarını erteleyebilirsin.',
  },
  BiorhythmItems.spiritual: {
    _BioPhase.d0:
        'Ruhsal enerjin dipte; iç huzur uzak görünüyor. Sessizlik, doğa ve '
        'nefes egzersizleriyle yavaşla.',
    _BioPhase.d1:
        'İçsel dinginliğin çok kırılgan. Yargılamadan dinlen, kendini '
        'zorlama.',
    _BioPhase.d2:
        'Ruhun yavaş yatışıyor. Küçük şükran anları ve sade ritüeller dengeni '
        'besler.',
    _BioPhase.d3:
        'İç huzurun geri geliyor. Kısa meditasyon ve içe dönük anlar iyi '
        'gelir.',
    _BioPhase.d4:
        'Ruhsal dengen ortalamaya yaklaşıyor. Sakin bir gün; farkındalık '
        'pratiklerine açıksın.',
    _BioPhase.d5:
        'İç dinginliğin ortanın üstünde. Anlam arayışına zaman ayırmak için '
        'uygun.',
    _BioPhase.d6:
        'Ruhsal farkındalığın iyi. Manevi pratiklerin ve içsel sorguların '
        'bugün derinleşir.',
    _BioPhase.d7:
        'İç huzurun yüksek; berraksın. Sezgisel-manevi içgörüler için verimli '
        'bir dönem.',
    _BioPhase.d8:
        'Ruhsal enerjin çok yüksek; derin bir denge içindesin. Bu huzuru '
        'çevrene de yansıt.',
    _BioPhase.d9:
        'Ruhsal olarak zirvedesin; sükûnet ve berraklık tavanda. İçsel '
        'bilgeliğini kararlarına taşı.',
    _BioPhase.critical:
        'Ruhsal ritmin kritik gününde — iç dengen oynak olabilir. Kendini '
        'zorlamadan, sabırla akışta kal.',
  },
};
