import 'package:flutter/material.dart';

import '../../data/database/app_database.dart';
import '../../data/models/ledger_model.dart';
import '../../data/models/person_model.dart';
import '../../data/models/transaction_model.dart';

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
        await database.insertLedger(LedgerModel(name: 'دفتر شخصي', currencyCode: 'YER'));
        ledgers = await database.getLedgers();
      }

      selectedLedger = ledgers.firstOrNull;
      if (selectedLedger != null) {
        await refreshLedgerData();
      }
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

  void setSelectedLedger(LedgerModel ledger) {
    selectedLedger = ledger;
    refreshLedgerData();
  }

  Future<void> addLedger(String name, String currencyCode) async {
    final ledger = LedgerModel(name: name, currencyCode: currencyCode);
    final createdId = await database.insertLedger(ledger);
    final created = LedgerModel(
      id: createdId,
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

extension ListFirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
