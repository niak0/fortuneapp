// Mock veri servisi
import 'package:fortuneapp/core/models/user_model.dart';
import 'package:fortuneapp/enums/relationship_status.dart';
import 'package:fortuneapp/enums/work_status.dart';
import 'package:fortuneapp/enums/zodiac_sign.dart';

class MockService {
  // Kullanıcı oturumu durumu
  static bool isUserLoggedIn = false;

  // Detaylı mock kullanıcı verisi
  static final UserModel mockUser = UserModel(
    name: 'Ayşe Yılmaz',
    birthDate: DateTime(1995, 5, 15),
    location: 'İstanbul',
    zodiacSign: ZodiacSign.taurus.name,
    gender: "Kadın",
    workState: WorkStatus.student.name,
    relationShipState: RelationshipStatus.inRelationship.name,
    coin: 250,
  );

  // Genişletilmiş mock fal geçmişi
  static final List<Map<String, dynamic>> mockFortuneHistory = [
    {
      'id': 'fortune_1',
      'createdTime': DateTime.now().subtract(const Duration(hours: 6)),
      'unlockTime': DateTime.now().add(const Duration(minutes: 15)),
      'fortune':
          'Kahve fincanınızda gördüğüm şekiller, yakın zamanda beklenmedik bir seyahat fırsatı doğacağını gösteriyor. Yolculuğunuzda yeni ve ilginç insanlarla tanışacaksınız.',
      'userId': 'mock_user_1',
      'fortuneType': 'coffee',
      'fortuneTopic': 'Genel',
      'isRead': false,
      'isAccessible': true,
    },
    {
      'id': 'fortune_2',
      'createdTime': DateTime.now().subtract(const Duration(days: 2)),
      'unlockTime': DateTime.now().add(const Duration(minutes: 30)),
      'fortune': 'Çektiğiniz Ay kartı, içsel yolculuğunuzun önemli bir dönemecinde olduğunuzu gösteriyor. Sezgileriniz her zamankinden güçlü.',
      'userId': 'mock_user_1',
      'fortuneType': 'tarot',
      'fortuneTopic': 'Aşk',
      'isRead': false,
      'isAccessible': false,
    },
    {
      'id': 'fortune_3',
      'createdTime': DateTime.now().subtract(const Duration(days: 4)),
      'unlockTime': DateTime.now(),
      'fortune':
          'Rüyanızda gördüğünüz mavi kuş, yakında alacağınız güzel bir haberin habercisi. Özellikle eğitim veya kariyer alanında beklediğiniz bir gelişme gerçekleşebilir.',
      'userId': 'mock_user_1',
      'fortuneType': 'dream',
      'fortuneTopic': 'Kariyer',
      'isRead': true,
      'isAccessible': true,
    },
    {
      'id': 'fortune_4',
      'createdTime': DateTime.now().subtract(const Duration(days: 7)),
      'unlockTime': DateTime.now().add(const Duration(minutes: 45)),
      'fortune':
          'Venüs-Jüpiter kavuşumu, önümüzdeki ay finansal konularda şanslı fırsatlar getirecek. Yatırımlarınız için uygun bir dönem yaklaşıyor.',
      'userId': 'mock_user_1',
      'fortuneType': 'astrology',
      'fortuneTopic': 'Finans',
      'isRead': false,
      'isAccessible': false,
    },
  ];

  // Kullanıcı istatistikleri
  static final Map<String, dynamic> mockUserStats = {
    'totalFortunes': 42,
    'favoriteFortuneType': 'Kahve Falı',
    'averageRating': 4.5,
    'mostFrequentTopic': 'Aşk',
    'longestStreak': 7,
    'currentStreak': 3,
    'goldEarned': 1500,
    'goldSpent': 1250,
  };

  // Profil güncelleme metodu
  static Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (updates.containsKey('name')) mockUser.name = updates['name'];
    if (updates.containsKey('birthDate')) mockUser.birthDate = updates['birthDate'];
    if (updates.containsKey('location')) mockUser.location = updates['location'];
    if (updates.containsKey('zodiacSign')) mockUser.zodiacSign = updates['zodiacSign'];
    if (updates.containsKey('gender')) mockUser.gender = updates['gender'];
    if (updates.containsKey('workState')) mockUser.workState = updates['workState'];
    if (updates.containsKey('relationShipState')) mockUser.relationShipState = updates['relationShipState'];
    if (updates.containsKey('coin')) mockUser.coin = updates['coin'];
  }

  // Fal notu ekleme/güncelleme
  static Future<void> updateFortuneNote(String fortuneId, String note) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final fortune = mockFortuneHistory.firstWhere((f) => f['id'] == fortuneId);
    fortune['userNotes'] = note;
  }

  // Fal değerlendirme
  static Future<void> rateForture(String fortuneId, int rating) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final fortune = mockFortuneHistory.firstWhere((f) => f['id'] == fortuneId);
    fortune['rating'] = rating;
  }

  // Kullanıcı istatistiklerini getir
  static Future<Map<String, dynamic>> getUserStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockUserStats;
  }

  // Mock numeroloji sonuçları
  static final Map<String, dynamic> mockNumerologyResults = {
    'lifePath': '7',
    'destiny': '4',
    'soulUrge': '3',
    'personality': '5',
  };

  // Mock burç verileri
  static final List<Map<String, dynamic>> mockZodiacModels = [
    {
      'sign': 'aries',
      'planet': 'Mars',
      'element': 'Ateş',
      'dateRange': '21 Mart - 20 Nisan',
      'loveScore': 8,
      'healthScore': 7,
      'moneyScore': 6,
      'motto': 'Ben varım!',
      'commentYesterday': 'Dün enerjiniz yüksekti...',
      'commentDaily': 'Bugün yeni başlangıçlar için uygun...',
      'commentWeekly': 'Bu hafta kariyer fırsatları kapınızı çalabilir...',
      'commentMonthly': 'Bu ay finansal konularda şanslısınız...',
      'commentYearly': '2024 yılı sizin için yeni başlangıçlar yılı olacak...',
    },
    {
      'sign': 'taurus',
      'planet': 'Venüs',
      'element': 'Toprak',
      'dateRange': '21 Nisan - 20 Mayıs',
      'loveScore': 9,
      'healthScore': 8,
      'moneyScore': 7,
      'motto': 'Sahip oluyorum!',
      'commentYesterday': 'Dün maddi konularda şanslıydınız...',
      'commentDaily': 'Bugün aşk hayatınızda güzel gelişmeler olabilir...',
      'commentWeekly': 'Bu hafta iş hayatınızda önemli gelişmeler yaşanabilir...',
      'commentMonthly': 'Bu ay ilişkileriniz güçlenecek...',
      'commentYearly': '2024 yılında finansal açıdan güçleneceksiniz...',
    },
    // Diğer burçlar için benzer veriler...
  ];

  // Burç verilerini getir
  static Future<List<Map<String, dynamic>>> getZodiacModels() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockZodiacModels;
  }

  // Mock doğum haritası verileri
  static final Map<String, dynamic> mockNatalData = {
    'ascendant': 'Yengeç',
    'sun': 'Koç',
    'moon': 'Terazi',
    'venus': 'Boğa',
    'mars': 'Aslan',
    'mercury': 'Balık',
  };

  // Mock Çin burcu verileri
  static final Map<String, dynamic> mockChineseZodiacData = {
    'sign': 'Ejderha',
    'element': 'Ateş',
    'compatibility': ['Maymun', 'Sıçan'],
    'characteristics': ['Güçlü', 'Karizmatik', 'Lider'],
    'yearlyForecast': '2024 yılında şans sizden yana...',
  };

  static Future<void> initializeData() async {
    // Mock verileri başlat
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Oturum açma simülasyonu
  static Future<bool> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    isUserLoggedIn = true;
    return true;
  }

  // Oturum kapatma
  static Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    isUserLoggedIn = false;
  }

  // Kullanıcı verilerini getir
  static Future<UserModel> getUserData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockUser;
  }

  // Fal geçmişini getir
  static Future<List<Map<String, dynamic>>> getFortuneHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockFortuneHistory;
  }

  // Yeni fal ekle
  static Future<void> addFortune(Map<String, dynamic> fortune) async {
    await Future.delayed(const Duration(milliseconds: 300));
    mockFortuneHistory.insert(0, {
      ...fortune,
      'createdTime': DateTime.now(),
      'unlockTime': DateTime.now().add(const Duration(minutes: 15)),
      'userId': 'mock_user_1',
      'isRead': false,
      'isAccessible': false,
    });
  }

  // Falı okundu olarak işaretle
  static Future<void> markFortuneAsRead(String fortuneId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final fortune = mockFortuneHistory.firstWhere((f) => f['id'] == fortuneId);
    fortune['isRead'] = true;
  }

  // Falı erişilebilir yap
  static Future<void> makeFortuneAccessible(String fortuneId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final fortune = mockFortuneHistory.firstWhere((f) => f['id'] == fortuneId);
    fortune['isAccessible'] = true;
  }

  // Altın miktarını güncelle
  static Future<void> updateGold(int amount) async {
    await Future.delayed(const Duration(milliseconds: 300));
    mockUser.coin = (mockUser.coin) + amount;
  }

  // Numeroloji sonuçlarını getir
  static Future<Map<String, dynamic>> getNumerologyResults() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockNumerologyResults;
  }

  // Doğum haritası verilerini getir
  static Future<Map<String, dynamic>> getNatalData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockNatalData;
  }

  // Çin burcu verilerini getir
  static Future<Map<String, dynamic>> getChineseZodiacData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockChineseZodiacData;
  }
}
