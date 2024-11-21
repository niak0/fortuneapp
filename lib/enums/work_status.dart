enum WorkStatus {
  student("Öğrenci"),
  employed("Çalışan"),
  unemployed("İşsiz"),
  retired("Emekli"),
  selfEmployed("Serbest Meslek");

  final String turkishName;
  const WorkStatus(this.turkishName);
}
