enum ZodiacSign {
  aries("♈", "Koç"),
  taurus("♉", "Boğa"),
  gemini("♊", "İkizler"),
  cancer("♋", "Yengeç"),
  leo("♌", "Aslan"),
  virgo("♍", "Başak"),
  libra("♎", "Terazi"),
  scorpio("♏", "Akrep"),
  sagittarius("♐", "Yay"),
  capricorn("♑", "Oğlak"),
  aquarius("♒", "Kova"),
  pisces("♓", "Balık");

  final String symbol;
  final String turkishName;

  const ZodiacSign(this.symbol, this.turkishName);
}
