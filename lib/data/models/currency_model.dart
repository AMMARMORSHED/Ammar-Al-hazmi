class CurrencyModel {
  final String code;
  final String nameAr;
  final String nameEn;
  final String symbol;
  final int decimalDigits;

  const CurrencyModel({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.symbol,
    this.decimalDigits = 2,
  });

  String displayName(bool isArabic) => isArabic ? nameAr : nameEn;

  static const List<CurrencyModel> defaultCurrencies = [
    CurrencyModel(code: 'YER', nameAr: 'ريال يمني', nameEn: 'Yemeni Rial', symbol: '﷼', decimalDigits: 0),
    CurrencyModel(code: 'SAR', nameAr: 'ريال سعودي', nameEn: 'Saudi Riyal', symbol: '﷼', decimalDigits: 2),
    CurrencyModel(code: 'USD', nameAr: 'دولار أمريكي', nameEn: 'US Dollar', symbol: '\$', decimalDigits: 2),
    CurrencyModel(code: 'AED', nameAr: 'درهم إماراتي', nameEn: 'UAE Dirham', symbol: 'د.إ', decimalDigits: 2),
    CurrencyModel(code: 'EUR', nameAr: 'يورو', nameEn: 'Euro', symbol: '€', decimalDigits: 2),
    CurrencyModel(code: 'GBP', nameAr: 'جنيه إسترليني', nameEn: 'British Pound', symbol: '£', decimalDigits: 2),
    CurrencyModel(code: 'EGP', nameAr: 'جنيه مصري', nameEn: 'Egyptian Pound', symbol: 'ج.م', decimalDigits: 2),
  ];
}
