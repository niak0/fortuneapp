
import 'package:flutter/material.dart';

enum BiorhythmItems {
  physical("Fiziksel"),
  emotional("Duygusal"),
  intellectual("Zihinsel");

  final String name;
  const BiorhythmItems(this.name);
}
extension BiorhythmItemsExtension on BiorhythmItems {


Color get color {
    switch (this) {
      case BiorhythmItems.physical:
        return Colors.green;
      case BiorhythmItems.emotional:
        return Colors.red;
      case BiorhythmItems.intellectual:
        return Colors.blue;
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
    }
  }

  int get cycle {
    switch (this) {
      case BiorhythmItems.physical:
        return 23;
      case BiorhythmItems.emotional:
        return 28;
      case BiorhythmItems.intellectual:
        return 33;
    }
  }

String getComment(int percentage) {
  if (percentage >= 0 && percentage <= 5) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Fiziksel enerjiniz en düşük seviyede. Vücudunuz dinlenmeye ihtiyaç duyuyor olabilir. Bugünü kendinize ayırın ve mümkünse stresten uzak durun. Hafif esneme hareketleri ve derin nefes egzersizleri size iyi gelebilir.";
      case BiorhythmItems.emotional:
        return "Duygusal olarak oldukça hassas hissedebilirsiniz. İç dünyanıza dönmek ve duygularınızı anlamak için zaman ayırın. Meditasyon veya günlük tutmak rahatlamanıza yardımcı olabilir.";
      case BiorhythmItems.intellectual:
        return "Zihinsel odaklanmanız düşük olabilir. Karmaşık görevlerden kaçınmak ve basit rutinlerle meşgul olmak en iyisi. Beyninize dinlenme fırsatı verin ve kendinizi zorlamayın.";
    }
  } else if (percentage > 5 && percentage <= 10) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Enerjiniz yavaş yavaş artıyor ancak hala düşük seviyede. Hafif yürüyüşler veya yumuşak egzersizler yapabilirsiniz. Bol su içmeyi ve dengeli beslenmeyi unutmayın.";
      case BiorhythmItems.emotional:
        return "Duygusal dalgalanmalar yaşayabilirsiniz. Sevdiklerinizle vakit geçirmek moralinizi yükseltebilir. Destek almaktan çekinmeyin ve duygularınızı paylaşın.";
      case BiorhythmItems.intellectual:
        return "Zihinsel berraklık henüz tam olarak geri dönmedi. Kısa süreli odaklanma gerektiren işleri tercih edin. Notlar almak ve hatırlatıcılar kullanmak faydalı olabilir.";
    }
  } else if (percentage > 10 && percentage <= 15) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Fiziksel olarak toparlanma sürecindesiniz. Enerji seviyeniz yükseliyor, ancak kendinizi yormamaya dikkat edin. Dengeli aktiviteler ve iyi bir uyku düzeni size yardımcı olacaktır.";
      case BiorhythmItems.emotional:
        return "Duygusal hassasiyet azalmaya başlıyor. İçsel dengeyi bulmak için doğada zaman geçirebilir veya sakinleştirici müzikler dinleyebilirsiniz.";
      case BiorhythmItems.intellectual:
        return "Zihinsel kapasiteniz artıyor. Basit planlamalar ve organizasyon işleri için uygun bir zaman. Yeni fikirler not alarak daha sonra değerlendirebilirsiniz.";
    }
  } else if (percentage > 15 && percentage <= 20) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Enerjiniz giderek yükseliyor. Hafif tempolu aktiviteler yapmak için ideal bir zaman. Vücudunuzu dinleyin ve sınırlarınızı zorlamamaya özen gösterin.";
      case BiorhythmItems.emotional:
        return "Duygusal olarak daha istikrarlısınız. Yaratıcı uğraşlara yönelmek ve hobilerinize zaman ayırmak sizi mutlu edebilir.";
      case BiorhythmItems.intellectual:
        return "Zihinsel olarak daha aktifsiniz. Öğrenme ve yeni bilgileri keşfetme isteği duyabilirsiniz. Online kurslar veya ilgi çekici makalelerle zaman geçirebilirsiniz.";
    }
  } else if (percentage > 20 && percentage <= 25) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Fiziksel enerjiniz ortalama seviyede. Günlük işlerinizi rahatlıkla yapabilirsiniz. Beslenmenize dikkat ederek enerjinizi daha da artırabilirsiniz.";
      case BiorhythmItems.emotional:
        return "Duygusal dengeye yaklaşıyorsunuz. Sosyal etkinlikler ve arkadaş buluşmaları için uygun bir zaman. Paylaşımlarınız size iyi gelecektir.";
      case BiorhythmItems.intellectual:
        return "Zihinsel performansınız iyiye gidiyor. Yeni projelere başlamak veya mevcutları ilerletmek için motivasyonunuz yüksek olabilir.";
    }
  } else if (percentage > 25 && percentage <= 30) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Enerjiniz artıyor ve kendinizi daha dinç hissediyorsunuz. Düzenli egzersizlerle bu enerjiyi değerlendirebilirsiniz.";
      case BiorhythmItems.emotional:
        return "Duygusal olarak rahat ve huzurlu bir dönemdesiniz. Sevdiklerinize zaman ayırmak ve duygusal bağlarınızı güçlendirmek için ideal bir gün.";
      case BiorhythmItems.intellectual:
        return "Zihinsel kapasiteniz yükseliyor. Problem çözme ve analiz gerektiren işler için uygun bir zaman. Fikirlerinizi başkalarıyla paylaşabilirsiniz.";
    }
  } else if (percentage > 30 && percentage <= 35) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Fiziksel olarak güçleniyorsunuz. Aktif olmak ve hareket etmek sizi daha da enerjik yapacaktır. Açık havada zaman geçirmek iyi bir fikir olabilir.";
      case BiorhythmItems.emotional:
        return "Duygusal dengeye sahipsiniz. İç huzurunuz yüksek, bu da çevrenize olumlu yansıyacaktır. Yeni insanlarla tanışmak için güzel bir gün.";
      case BiorhythmItems.intellectual:
        return "Zihinsel olarak yaratıcı fikirler üretebilirsiniz. Beyin fırtınası yapmak ve yeni projeler planlamak için harika bir zaman.";
    }
  } else if (percentage > 35 && percentage <= 40) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Enerji seviyeniz iyi durumda. Spor yapmak veya fiziksel aktivitelerde bulunmak için motive hissedebilirsiniz.";
      case BiorhythmItems.emotional:
        return "Duygusal olarak kendinizi güvende ve mutlu hissediyorsunuz. Sanatsal faaliyetler veya hobilerle ilgilenmek size keyif verecektir.";
      case BiorhythmItems.intellectual:
        return "Zihinsel performansınız dengeli. Planlama ve organizasyon işleri için uygun bir dönem. Verimli çalışabilirsiniz.";
    }
  } else if (percentage > 40 && percentage <= 45) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Fiziksel enerjiniz yükselmeye devam ediyor. Yeni sporlar denemek veya aktif etkinliklere katılmak için harika bir zaman.";
      case BiorhythmItems.emotional:
        return "Duygusal olarak pozitif bir dönemdesiniz. Empati yeteneğiniz yüksek, bu da ilişkilerinizi olumlu etkileyebilir.";
      case BiorhythmItems.intellectual:
        return "Zihinsel olarak keskinsiniz. Karmaşık problemleri çözmek ve stratejik düşünmek için ideal bir zaman.";
    }
  } else if (percentage > 45 && percentage <= 50) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Enerji seviyeniz oldukça iyi. Uzun vadeli fiziksel hedefler belirlemek için motive hissedebilirsiniz.";
      case BiorhythmItems.emotional:
        return "Duygusal denge ve mutluluk hissi yüksek. Sevdiklerinizle derin sohbetler yapmak için güzel bir gün.";
      case BiorhythmItems.intellectual:
        return "Zihinsel kapasiteniz yüksek. Öğrenme ve öğretme faaliyetlerinde başarılı olabilirsiniz.";
    }
  } else if (percentage > 50 && percentage <= 55) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Fiziksel performansınız iyi seviyede. Enerjinizi yararlı aktivitelere yönlendirmek size fayda sağlayacaktır.";
      case BiorhythmItems.emotional:
        return "Duygusal olarak kendinizi ifade etmekte rahat hissediyorsunuz. Yaratıcı projelere katılabilirsiniz.";
      case BiorhythmItems.intellectual:
        return "Zihinsel olarak üretkensiniz. Yeni fikirler ve inovasyon için ideal bir zaman.";
    }
  } else if (percentage > 55 && percentage <= 60) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Enerjiniz yüksek ve stabil. Fiziksel hedeflerinize ulaşmak için iyi bir motivasyona sahipsiniz.";
      case BiorhythmItems.emotional:
        return "Duygusal bağlarınız güçleniyor. Aile ve arkadaşlarla vakit geçirmek size iyi gelecektir.";
      case BiorhythmItems.intellectual:
        return "Zihinsel berraklık üst düzeyde. Zor görevleri kolaylıkla tamamlayabilirsiniz.";
    }
  } else if (percentage > 60 && percentage <= 65) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Fiziksel olarak kendinizi harika hissediyorsunuz. Yeni spor hedefleri belirlemek için ideal bir zaman.";
      case BiorhythmItems.emotional:
        return "Duygusal enerjiniz yüksek. Sevgi ve şefkat duygularınız artıyor, bu da ilişkilerinizi olumlu etkiliyor.";
      case BiorhythmItems.intellectual:
        return "Zihinsel kapasiteniz zirveye yaklaşıyor. Stratejik planlar ve önemli kararlar için uygun bir dönem.";
    }
  } else if (percentage > 65 && percentage <= 70) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Enerjiniz doruk noktasına yaklaşıyor. Fiziksel aktivitelerde performansınız artıyor. Kendinizi aşmaya hazır hissedebilirsiniz.";
      case BiorhythmItems.emotional:
        return "Duygusal olarak çok olumlusunuz. İnsanlarla kolayca bağlantı kurabilir ve yeni dostluklar edinebilirsiniz.";
      case BiorhythmItems.intellectual:
        return "Zihinsel olarak çok aktifsiniz. Karmaşık projelere odaklanmak ve yenilikçi çözümler bulmak için harika bir zaman.";
    }
  } else if (percentage > 70 && percentage <= 75) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Fiziksel performansınız yüksek. Spor ve egzersizlerden büyük keyif alabilirsiniz. Enerjinizi olumlu yönde kullanın.";
      case BiorhythmItems.emotional:
        return "Duygusal enerjiniz zirvede. Sevgi ve mutluluk dolu bir dönemdesiniz. Sevdiklerinize zaman ayırın.";
      case BiorhythmItems.intellectual:
        return "Zihinsel kapasiteniz çok yüksek. Yeni şeyler öğrenmek ve öğretmek için mükemmel bir zaman.";
    }
  } else if (percentage > 75 && percentage <= 80) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Enerjiniz en üst seviyelere ulaşıyor. Fiziksel sınırlarınızı zorlamak isteyebilirsiniz, ancak dikkatli olun ve vücudunuzu dinleyin.";
      case BiorhythmItems.emotional:
        return "Duygusal olarak harika hissediyorsunuz. Pozitif enerjiniz çevrenizdekilere de yansıyacaktır.";
      case BiorhythmItems.intellectual:
        return "Zihinsel olarak zirvedesiniz. Karmaşık sorunları çözmek ve yaratıcı fikirler üretmek için ideal bir zaman.";
    }
  } else if (percentage > 80 && percentage <= 85) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Fiziksel olarak mükemmel hissediyorsunuz. Uzun süreli fiziksel aktiviteler için enerjiniz yüksek.";
      case BiorhythmItems.emotional:
        return "Duygusal enerjiniz çok yüksek. İlişkilerinizde derinleşme ve yeni başlangıçlar için uygun bir zaman.";
      case BiorhythmItems.intellectual:
        return "Zihinsel performansınız mükemmel. Liderlik ve yönlendirme gerektiren görevlerde başarılı olabilirsiniz.";
    }
  } else if (percentage > 85 && percentage <= 90) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Enerjiniz dorukta! Fiziksel aktivitelerde üstün performans gösterebilirsiniz. Ancak dinlenmeyi ihmal etmeyin.";
      case BiorhythmItems.emotional:
        return "Duygusal olarak çok güçlüsünüz. Sevdiklerinizle derin bağlar kurmak için harika bir zaman.";
      case BiorhythmItems.intellectual:
        return "Zihinsel olarak olağanüstü bir dönemdesiniz. Büyük fikirler ve projeler için mükemmel bir zaman.";
    }
  } else if (percentage > 90 && percentage <= 95) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Fiziksel enerjiniz en üst seviyede. Kendinizi yenilmez hissedebilirsiniz, ancak aşırıya kaçmamaya dikkat edin.";
      case BiorhythmItems.emotional:
        return "Duygusal olarak en üst noktadasınız. Sevgi ve mutluluk sizi çevreliyor. Bu enerjiyi başkalarıyla paylaşın.";
      case BiorhythmItems.intellectual:
        return "Zihinsel kapasiteniz zirvede. En karmaşık görevleri bile kolaylıkla halledebilirsiniz.";
    }
  } else if (percentage > 95 && percentage <= 100) {
    switch (this) {
      case BiorhythmItems.physical:
        return "Fiziksel olarak en güçlü döneminizi yaşıyorsunuz. Enerjinizi büyük hedeflere yönlendirmek için harika bir zaman.";
      case BiorhythmItems.emotional:
        return "Duygusal enerjiniz zirvede! Sevgi dolu ve mutlu bir ruh hali içindesiniz. Bu olumlu enerjiyi etrafınıza yayabilirsiniz.";
      case BiorhythmItems.intellectual:
        return "Zihinsel performansınız en üst seviyede. Yaratıcılığınız ve keskin zekânızla büyük işler başarabilirsiniz.";
    }
  } else {
    return "Bilinmeyen bir değer girdiniz. Lütfen yüzdeyi 0 ile 100 arasında bir değer olarak girin.";
  }
}

}