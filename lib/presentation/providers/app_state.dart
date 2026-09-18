import 'package:flutter/foundation.dart';
import '../data/database/database_service.dart';
import '../data/models/models.dart';
class AppState extends ChangeNotifier { final DatabaseService database=DatabaseService.instance; List<Ledger> ledgers=[]; List<Person> people=[]; List<TransactionItem> tx=[]; Ledger? currentLedger; Map<String,double> totals={'receivable':0,'payable':0,'net':0}; String search=''; LocalePreference language=LocalePreference.system; ThemePreference theme=ThemePreference.system;
 Future<void> init() async{ledgers=await database.ledgers();currentLedger=ledgers.first;await refresh();}
 Future<void> refresh() async{if(currentLedger==null)return;people=await database.persons(currentLedger!.id!,query:search);tx=await database.transactions(currentLedger!.id!,query:search);totals=await database.totals(currentLedger!.id!);notifyListeners();}
 void selectLedger(Ledger x){currentLedger=x;refresh();} Future<void> addPerson(Person x)async{await database.addPerson(x);await refresh();} Future<void> addTx(TransactionItem x)async{await database.addTransaction(x);await refresh();} Future<void> removeTx(int id)async{await database.deleteTransaction(id);await refresh();} Future<void> removePerson(int id)async{await database.deletePerson(id);await refresh();} Future<void> addLedger(String name,String currency)async{final id=await database.addLedger(Ledger(name:name,currencyCode:currency));ledgers=await database.ledgers();currentLedger=ledgers.firstWhere((x)=>x.id==id);await refresh();}
}
enum LocalePreference {system,ar,en} enum ThemePreference {system,light,dark}
