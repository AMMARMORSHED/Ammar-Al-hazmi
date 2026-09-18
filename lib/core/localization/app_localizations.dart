import 'package:flutter/material.dart';

class AppLocalizations {
  static const supportedLocales = [Locale('ar'), Locale('en')];

  static const delegate = _AppLocalizationsDelegate();

  final Locale locale;

  const AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  bool get isArabic => locale.languageCode == 'ar';

  String get currentLanguageName => isArabic ? 'العربية' : 'English';

  String tr(String key) {
    final map = _values[key];
    if (map == null) return key;
    return map[locale.languageCode] ?? map['en'] ?? key;
  }

  static final Map<String, Map<String, String>> _values = {
    'app_name': {'ar': 'دفتر الحسابات', 'en': 'Daftar Alhisabat'},
    'home': {'ar': 'الرئيسية', 'en': 'Home'},
    'accounts': {'ar': 'الحسابات', 'en': 'Accounts'},
    'transactions': {'ar': 'العمليات', 'en': 'Transactions'},
    'reports': {'ar': 'التقارير', 'en': 'Reports'},
    'settings': {'ar': 'الإعدادات', 'en': 'Settings'},
    'total_receivable': {'ar': 'إجمالي ما لي', 'en': 'Total receivable'},
    'total_payable': {'ar': 'إجمالي ما عليّ', 'en': 'Total payable'},
    'net_balance': {'ar': 'صافي الرصيد', 'en': 'Net balance'},
    'people_count': {'ar': 'عدد الأشخاص', 'en': 'People count'},
    'recent_transactions': {'ar': 'آخر العمليات', 'en': 'Recent transactions'},
    'add_person': {'ar': 'إضافة شخص', 'en': 'Add person'},
    'add_transaction': {'ar': 'إضافة عملية', 'en': 'Add transaction'},
    'name': {'ar': 'الاسم', 'en': 'Name'},
    'phone': {'ar': 'رقم الهاتف', 'en': 'Phone'},
    'description': {'ar': 'الوصف', 'en': 'Description'},
    'amount': {'ar': 'المبلغ', 'en': 'Amount'},
    'date': {'ar': 'التاريخ', 'en': 'Date'},
    'currency': {'ar': 'العملة', 'en': 'Currency'},
    'ledger': {'ar': 'الدفتر', 'en': 'Ledger'},
    'save': {'ar': 'حفظ', 'en': 'Save'},
    'cancel': {'ar': 'إلغاء', 'en': 'Cancel'},
    'delete': {'ar': 'حذف', 'en': 'Delete'},
    'edit': {'ar': 'تعديل', 'en': 'Edit'},
    'search': {'ar': 'بحث', 'en': 'Search'},
    'type': {'ar': 'النوع', 'en': 'Type'},
    'receivable': {'ar': 'لي عنده', 'en': 'Receivable'},
    'payable': {'ar': 'عليّ له', 'en': 'Payable'},
    'received': {'ar': 'استلام', 'en': 'Received'},
    'paid': {'ar': 'دفعة', 'en': 'Paid'},
    'balance': {'ar': 'الرصيد', 'en': 'Balance'},
    'language': {'ar': 'اللغة', 'en': 'Language'},
    'theme': {'ar': 'المظهر', 'en': 'Theme'},
    'light': {'ar': 'فاتح', 'en': 'Light'},
    'dark': {'ar': 'داكن', 'en': 'Dark'},
    'system': {'ar': 'حسب النظام', 'en': 'System'},
    'error_generic': {'ar': 'حدث خطأ أثناء حفظ العملية. يرجى المحاولة مرة أخرى.', 'en': 'Something went wrong while saving. Please try again.'},
    'no_accounts': {'ar': 'لا توجد حسابات بعد', 'en': 'No accounts yet'},
    'no_transactions': {'ar': 'لا توجد عمليات', 'en': 'No transactions'},
    'start_now': {'ar': 'ابدأ الآن', 'en': 'Start now'},
    'confirm_delete': {'ar': 'هل أنت متأكد من حذف هذا العنصر؟', 'en': 'Are you sure you want to delete this item?'},
    'close_account': {'ar': 'إغلاق الحساب', 'en': 'Close account'},
    'reopen_account': {'ar': 'إعادة فتح الحساب', 'en': 'Reopen account'},
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
