import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/currency_model.dart';
import '../models/ledger_model.dart';
import '../models/person_model.dart';
import '../models/transaction_model.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static Database? _database;

  Future<Database> initialize() async {
    if (_database != null) return _database!;

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'daftar_alhisabat.db');

    _database = await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDatabase,
    );

    return _database!;
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE currencies (
        code TEXT PRIMARY KEY,
        name_ar TEXT,
        name_en TEXT,
        symbol TEXT,
        decimal_digits INTEGER
      )
    ''');

    for (final currency in CurrencyModel.defaultCurrencies) {
      await db.insert('currencies', {
        'code': currency.code,
        'name_ar': currency.nameAr,
        'name_en': currency.nameEn,
        'symbol': currency.symbol,
        'decimal_digits': currency.decimalDigits,
      });
    }

    await db.execute('''
      CREATE TABLE ledgers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        currency_code TEXT NOT NULL,
        is_closed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE persons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ledger_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        phone TEXT,
        address TEXT,
        notes TEXT,
        kind TEXT,
        photo_path TEXT,
        FOREIGN KEY (ledger_id) REFERENCES ledgers(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ledger_id INTEGER NOT NULL,
        person_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        description TEXT,
        category TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (ledger_id) REFERENCES ledgers(id) ON DELETE CASCADE,
        FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('CREATE INDEX idx_transactions_ledger_date ON transactions(ledger_id, date)');
    await db.execute('CREATE INDEX idx_persons_ledger ON persons(ledger_id)');

    await db.insert('ledgers', {
      'name': 'دفتر شخصي',
      'currency_code': 'YER',
      'is_closed': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<Database> get database async {
    return _database ?? await initialize();
  }

  Future<List<LedgerModel>> getLedgers() async {
    final db = await database;
    final rows = await db.query('ledgers', orderBy: 'id DESC');
    return rows.map((row) => LedgerModel.fromMap(row)).toList();
  }

  Future<int> insertLedger(LedgerModel ledger) async {
    final db = await database;
    return db.insert('ledgers', ledger.toMap());
  }

  Future<List<PersonModel>> getPersons(int ledgerId) async {
    final db = await database;
    final rows = await db.query(
      'persons',
      where: 'ledger_id = ?',
      whereArgs: [ledgerId],
      orderBy: 'name ASC',
    );
    return rows.map((row) => PersonModel.fromMap(row)).toList();
  }

  Future<int> insertPerson(PersonModel person) async {
    final db = await database;
    return db.insert('persons', person.toMap());
  }

  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    return db.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getTransactions({int? ledgerId, int? personId}) async {
    final db = await database;

    String? where;
    List<Object?> whereArgs = [];
    if (ledgerId != null) {
      where = 'ledger_id = ?';
      whereArgs = [ledgerId];
    }
    if (personId != null) {
      if (where == null) {
        where = 'person_id = ?';
      } else {
        where += ' AND person_id = ?';
      }
      whereArgs.add(personId);
    }

    final rows = await db.query(
      'transactions',
      where: where,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'date DESC, id DESC',
    );

    return rows.map((row) => TransactionModel.fromMap(row)).toList();
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deletePerson(int id) async {
    final db = await database;
    await db.delete('persons', where: 'id = ?', whereArgs: [id]);
  }
}
