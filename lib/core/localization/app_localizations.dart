import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);
  static const supportedLocales = [Locale('ar'), Locale('en')];
  static AppLocalizations of(BuildContext context) => Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  bool get isArabic => locale.languageCode == 'ar';
  TextDirection get direction => isArabic ? TextDirection.rtl : TextDirection.ltr;
  String t(String key) => _values[key]?[isArabic ? 'ar' : 'en'] ?? key;
  String date(DateTime d) => DateFormat(isArabic ? 'yyyy/MM/dd' : 'dd/MM/yyyy', locale.languageCode).format(d);
  String money(num value, String code, int digits) => '${NumberFormat.currency(symbol: '', decimalDigits: digits, locale: locale.languageCode).format(value)} $code';
  static final Map<String, Map<String, String>> _values = {
    'appName': {'ar':'دفتر الحسابات','en':'Daftar Alhisabat'}, 'home': {'ar':'الرئيسية','en':'Home'},
    'accounts': {'ar':'الحسابات','en':'Accounts'}, 'transactions': {'ar':'العمليات','en':'Transactions'},
    'reports': {'ar':'التقارير','en':'Reports'}, 'settings': {'ar':'الإعدادات','en':'Settings'},
    'receivable': {'ar':'لي عنده','en':'Receivable'}, 'payable': {'ar':'عليّ له','en':'Payable'},
    'received': {'ar':'استلام','en':'Received'}, 'paid': {'ar':'دفعة','en':'Paid'},
    'balance': {'ar':'الرصيد','en':'Balance'}, 'totalReceivable': {'ar':'إجمالي ما لي','en':'Total receivable'},
    'totalPayable': {'ar':'إجمالي ما عليّ','en':'Total payable'}, 'net': {'ar':'صافي الرصيد','en':'Net balance'},
    'addPerson': {'ar':'إضافة شخص','en':'Add person'}, 'addTransaction': {'ar':'إضافة عملية','en':'Add transaction'},
    'name': {'ar':'الاسم','en':'Name'}, 'phone': {'ar':'رقم الهاتف','en':'Phone'}, 'amount': {'ar':'المبلغ','en':'Amount'},
    'description': {'ar':'الوصف','en':'Description'}, 'save': {'ar':'حفظ','en':'Save'}, 'cancel': {'ar':'إلغاء','en':'Cancel'},
    'delete': {'ar':'حذف','en':'Delete'}, 'edit': {'ar':'تعديل','en':'Edit'}, 'search': {'ar':'بحث','en':'Search'},
    'noData': {'ar':'لا توجد بيانات بعد','en':'No data yet'}, 'ledger': {'ar':'الدفتر','en':'Ledger'},
    'currency': {'ar':'العملة','en':'Currency'}, 'ledgers': {'ar':'دفاتري','en':'My ledgers'},
    'language': {'ar':'اللغة','en':'Language'}, 'theme': {'ar':'المظهر','en':'Theme'},
    'light': {'ar':'فاتح','en':'Light'}, 'dark': {'ar':'داكن','en':'Dark'}, 'system': {'ar':'حسب النظام','en':'System'},
    'error': {'ar':'حدث خطأ، يرجى المحاولة مرة أخرى','en':'Something went wrong. Please try again.'},
    'required': {'ar':'هذا الحقل مطلوب','en':'This field is required'}, 'confirmDelete': {'ar':'هل أنت متأكد من الحذف؟','en':'Are you sure you want to delete?'},
    'all': {'ar':'الكل','en':'All'}, 'recent': {'ar':'آخر العمليات','en':'Recent transactions'}, 'closeAccount': {'ar':'إغلاق الحساب','en':'Close account'},
    'reportsSoon': {'ar':'التقارير والتصدير متاحان من تفاصيل الحساب','en':'Reports and export are available from account details'},
  };
}
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  @override bool isSupported(Locale l) => ['ar','en'].contains(l.languageCode);
  @override Future<AppLocalizations> load(Locale l) async => AppLocalizations(l);
  @override bool shouldReload(AppLocalizationsDelegate old) => false;
}
