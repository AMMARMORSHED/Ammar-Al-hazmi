# دفتر الحسابات | Daftar Alhisabat

تطبيق Flutter لإدارة الديون والحسابات الشخصية والتجارية، يعمل Offline-first باستخدام SQLite، ويدعم العربية RTL وEnglish LTR، الدفاتر المتعددة والعملات والتقارير والتصدير.

## المتطلبات
- Flutter 3.22+ / Dart 3.3+
- Android Studio أو VS Code
- Android SDK 21+

## التشغيل والبناء
```bash
flutter pub get
flutter analyze
flutter test
flutter run
flutter build apk --release
```

## البنية
- `lib/data/database`: مخطط SQLite وعمليات النسخ الاحتياطي.
- `lib/data/models`: نماذج البيانات والتحويل إلى SQLite.
- `lib/data/repositories`: مصدر الحقيقة للدفاتر والأشخاص والعمليات.
- `lib/services`: PDF/Excel/مشاركة/تنبيهات.
- `lib/presentation`: الشاشات والمكونات وProvider state.
- `lib/core`: الثوابت، التنسيق، الثيم، والتعريب.

كل الرصيد مشتق من العمليات: `receivable - payable`. الدفع والاستلام يغيران الاتجاه المحاسبي ولا يتم تخزين الرصيد كحقيقة نهائية.

## قاعدة البيانات
الإصدار الحالي 1 ويحتوي على ledgers, currencies, persons, categories, transactions, attachments, reminders, account_closures, app_settings, audit_log, exchange_rates. توجد Foreign Keys وفهارس وعمليات migration.

## إضافة لغة أو عملة
أضف مفاتيح اللغة إلى `lib/core/localization/app_localizations.dart` وإلى ملفات `lib/l10n/app_*.arb`. أضف العملة إلى `CurrencyCatalog` أو جدول currencies في migration.

## التصدير والخصوصية
PDF وExcel ونسخ JSON الاحتياطية تعمل محلياً وتستخدم Android Share Sheet. لا توجد اتصالات خادم ولا API keys. يمكن لاحقاً إضافة Cloud Sync عبر Repository interface دون تغيير واجهة المستخدم.

## ملاحظات Android
للتذكيرات استخدم إذن POST_NOTIFICATIONS في Android 13+. للبصمة أضف USE_BIOMETRIC. لا تُطلب صلاحيات الملفات العامة؛ File Picker وShare Sheet يستخدمان Storage Access Framework.
