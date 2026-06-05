// Burç referans verisi (statik, mock değil — uygulama bundle'ı).
// İleride Firestore'a taşınabilir.
const List<Map<String, dynamic>> zodiacReferenceData = [
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
    'commentYearly': '2026 yılı sizin için yeni başlangıçlar yılı olacak...',
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
    'commentYearly': '2026 yılında finansal açıdan güçleneceksiniz...',
  },
];
