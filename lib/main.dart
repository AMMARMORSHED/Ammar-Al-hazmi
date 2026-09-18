import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/app_state.dart';
import 'presentation/screens/home_screen.dart';
void main() async { WidgetsFlutterBinding.ensureInitialized(); final state=AppState(); await state.init(); runApp(ChangeNotifierProvider.value(value:state,child:const DaftarApp())); }
class DaftarApp extends StatelessWidget { const DaftarApp({super.key}); @override Widget build(BuildContext context){return MaterialApp(title:'Daftar Alhisabat',debugShowCheckedModeBanner:false,theme:AppTheme.light,darkTheme:AppTheme.dark,localizationsDelegates:const [AppLocalizationsDelegate(),DefaultMaterialLocalizations.delegate,DefaultWidgetsLocalizations.delegate],supportedLocales:AppLocalizations.supportedLocales,locale:const Locale('ar'),builder:(c,w)=>Directionality(textDirection:AppLocalizations.of(c).direction,child:w!),home:const HomeScreen());} }
