enum AnimalEnum {
  rat(
    turkishName: 'Fare',
    element: 'Su',
    rulingPlanet: 'Jüpiter',
    luckyNumbers: [2, 3],
    luckyStones: ['Nar taşı'],
  ),
  ox(
    turkishName: 'Öküz',
    element: 'Toprak',
    rulingPlanet: 'Satürn',
    luckyNumbers: [1, 9],
    luckyStones: ['Safir'],
  ),
  tiger(
    turkishName: 'Kaplan',
    element: 'Ağaç',
    rulingPlanet: 'Mars',
    luckyNumbers: [1, 3],
    luckyStones: ['Zümrüt'],
  ),
  rabbit(
    turkishName: 'Tavşan',
    element: 'Ağaç',
    rulingPlanet: 'Venüs',
    luckyNumbers: [3, 4],
    luckyStones: ['İnci'],
  ),
  dragon(
    turkishName: 'Ejderha',
    element: 'Toprak',
    rulingPlanet: 'Güneş',
    luckyNumbers: [1, 6],
    luckyStones: ['Amber'],
  ),
  snake(
    turkishName: 'Yılan',
    element: 'Ateş',
    rulingPlanet: 'Merkür',
    luckyNumbers: [2, 8],
    luckyStones: ['Topaz'],
  ),
  horse(
    turkishName: 'At',
    element: 'Ateş',
    rulingPlanet: 'Mars',
    luckyNumbers: [2, 7],
    luckyStones: ['Safir'],
  ),
  goat(
    turkishName: 'Koyun',
    element: 'Toprak',
    rulingPlanet: 'Ay',
    luckyNumbers: [3, 9],
    luckyStones: ['Mercan'],
  ),
  monkey(
    turkishName: 'Maymun',
    element: 'Metal',
    rulingPlanet: 'Venüs',
    luckyNumbers: [4, 5],
    luckyStones: ['Akuamarin'],
  ),
  rooster(
    turkishName: 'Horoz',
    element: 'Metal',
    rulingPlanet: 'Venüs',
    luckyNumbers: [5, 7],
    luckyStones: ['Opal'],
  ),
  dog(
    turkishName: 'Köpek',
    element: 'Toprak',
    rulingPlanet: 'Satürn',
    luckyNumbers: [3, 9],
    luckyStones: ['Elmas'],
  ),
  pig(
    turkishName: 'Domuz',
    element: 'Su',
    rulingPlanet: 'Jüpiter',
    luckyNumbers: [2, 5],
    luckyStones: ['Ametist'],
  );

  final String turkishName;
  final String element;
  final String rulingPlanet;
  final List<int> luckyNumbers;
  final List<String> luckyStones;

  const AnimalEnum({
    required this.turkishName,
    required this.element,
    required this.rulingPlanet,
    required this.luckyNumbers,
    required this.luckyStones,
  });

  static AnimalEnum calculateChineseZodiac(DateTime birthDate) {
    int baseYear = 1900; // Çin Zodyak döngüsünün başladığı yıl
    int birthYear = birthDate.year;

    // Çin Yeni Yılı Ocak/Şubat arasında olduğundan, doğum tarihi Çin Yeni Yılı'ndan önce mi kontrol ediyoruz
    DateTime chineseNewYear = getChineseNewYear(birthYear);
    if (birthDate.isBefore(chineseNewYear)) {
      birthYear -= 1; // Çin Yeni Yılı'ndan önce doğanlar bir önceki yıla ait
    }

    int index = (birthYear - baseYear) % 12;
    return AnimalEnum.values[index];
  }

  static DateTime getChineseNewYear(int year) {
    final Map<int, DateTime> chineseNewYearDates = {
      1970: DateTime(1970, 2, 6),
      1971: DateTime(1971, 1, 27),
      1972: DateTime(1972, 2, 15),
      1973: DateTime(1973, 2, 3),
      1974: DateTime(1974, 1, 23),
      1975: DateTime(1975, 2, 11),
      1976: DateTime(1976, 1, 31),
      1977: DateTime(1977, 2, 18),
      1978: DateTime(1978, 2, 7),
      1979: DateTime(1979, 1, 28),
      1980: DateTime(1980, 2, 16),
      1981: DateTime(1981, 2, 5),
      1982: DateTime(1982, 1, 25),
      1983: DateTime(1983, 2, 13),
      1984: DateTime(1984, 2, 2),
      1985: DateTime(1985, 2, 20),
      1986: DateTime(1986, 2, 9),
      1987: DateTime(1987, 1, 29),
      1988: DateTime(1988, 2, 17),
      1989: DateTime(1989, 2, 6),
      1990: DateTime(1990, 1, 27),
      1991: DateTime(1991, 2, 15),
      1992: DateTime(1992, 2, 4),
      1993: DateTime(1993, 1, 23),
      1994: DateTime(1994, 2, 10),
      1995: DateTime(1995, 1, 31),
      1996: DateTime(1996, 2, 19),
      1997: DateTime(1997, 2, 7),
      1998: DateTime(1998, 1, 28),
      1999: DateTime(1999, 2, 16),
      2000: DateTime(2000, 2, 5),
      2001: DateTime(2001, 1, 24),
      2002: DateTime(2002, 2, 12),
      2003: DateTime(2003, 2, 1),
      2004: DateTime(2004, 1, 22),
      2005: DateTime(2005, 2, 9),
      2006: DateTime(2006, 1, 29),
      2007: DateTime(2007, 2, 18),
      2008: DateTime(2008, 2, 7),
      2009: DateTime(2009, 1, 26),
      2010: DateTime(2010, 2, 14),
      2011: DateTime(2011, 2, 3),
      2012: DateTime(2012, 1, 23),
      2013: DateTime(2013, 2, 10),
      2014: DateTime(2014, 1, 31),
      2015: DateTime(2015, 2, 19),
      2016: DateTime(2016, 2, 8),
      2017: DateTime(2017, 1, 28),
      2018: DateTime(2018, 2, 16),
      2019: DateTime(2019, 2, 5),
      2020: DateTime(2020, 1, 25),
      2021: DateTime(2021, 2, 12),
      2022: DateTime(2022, 2, 1),
      2023: DateTime(2023, 1, 22),
      2024: DateTime(2024, 2, 10),
      2025: DateTime(2025, 1, 29),
    };

    return chineseNewYearDates[year] ?? DateTime(year, 2, 4); // Varsayılan olarak Şubat başını döndürüyor
  }
}