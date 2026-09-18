import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../data/models/ledger_model.dart';
import '../../data/models/person_model.dart';
import '../../data/models/transaction_model.dart';
import '../database/app_database.dart';

class AppState extends ChangeNotifier {
  AppState(this.database);

  final AppDatabase database;

  List<LedgerModel> ledgers = [];
  List<PersonModel> persons = [];
  List<TransactionModel> transactions = [];
  LedgerModel? selectedLedger;
  bool isBusy = false;

  Future<void> loadInitial() async {
    isBusy = true;
    notifyListeners();

    try {
      ledgers = await database.getLedgers();
      if (ledgers.isEmpty) {
        final created = await database.insertLedger(
          LedgerModel(name: 'دفتر شخصي', currencyCode: 'YER'),
        );
        final defaultLedger = LedgerModel(
          id: created,
          name: 'دفتر شخصي',
          currencyCode: 'YER',
        );
        ledgers = [defaultLedger];
      }

      selectedLedger = ledgers.first;
      await refreshLedgerData();
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> refreshLedgerData() async {
    if (selectedLedger == null) return;

    persons = await database.getPersons(selectedLedger!.id!);
    transactions = await database.getTransactions(ledgerId: selectedLedger!.id!);
    notifyListeners();
  }

  Future<void> addLedger(String name, String currencyCode) async {
    final ledger = LedgerModel(name: name, currencyCode: currencyCode);
    final newId = await database.insertLedger(ledger);
    final created = LedgerModel(
      id: newId,
      name: name,
      currencyCode: currencyCode,
    );
    ledgers.insert(0, created);
    selectedLedger = created;
    await refreshLedgerData();
  }

  Future<void> addPerson(PersonModel person) async {
    if (selectedLedger == null) return;
    await database.insertPerson(person);
    await refreshLedgerData();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    if (selectedLedger == null) return;
    await database.insertTransaction(transaction);
    await refreshLedgerData();
  }

  Future<void> deleteTransaction(int id) async {
    await database.deleteTransaction(id);
    await refreshLedgerData();
  }

  Future<void> deletePerson(int id) async {
    await database.deletePerson(id);
    await refreshLedgerData();
  }

  double get totalReceivable {
    return transactions
        .where((value) => value.type == 'receivable' || value.type == 'received')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalPayable {
    return transactions
        .where((value) => value.type == 'payable' || value.type == 'paid')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get netBalance => totalReceivable - totalPayable;

  Locale get locale => const Locale('ar');

  String currencySymbol() {
    if (selectedLedger == null) return 'YER';
    return selectedLedger!.currencyCode;
  }

  Map<String, dynamic> personBalance(PersonModel person) {
    final personTransactions = transactions.where((t) => t.personId == person.id).toList();
    double receivable = 0;
    double payable = 0;

    for (final transaction in personTransactions) {
      if (transaction.type == 'receivable' || transaction.type == 'received') {
        receivable += transaction.amount;
      }
      if (transaction.type == 'payable' || transaction.type == 'paid') {
        payable += transaction.amount;
      }
    }

    return {
      'receivable': receivable,
      'payable': payable,
      'net': receivable - payable,
    };
  }
}
