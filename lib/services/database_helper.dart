// File: lib/services/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/employee_model.dart';

class DatabaseHelper {
  static const _databaseName = "KasirSwalayanDB.db";
  static const _databaseVersion = 2; // Versi 2 untuk fitur login kasir

  static const tableTransactions = 'transactions';
  static const tableEmployees = 'employees';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Tabel Employees
    await db.execute('''
      CREATE TABLE $tableEmployees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // Tabel Transactions dengan relasi employee_id
    await db.execute('''
      CREATE TABLE $tableTransactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        receipt_number TEXT NOT NULL,
        total_amount REAL NOT NULL,
        date TEXT NOT NULL,
        payment_method TEXT NOT NULL,
        employee_id INTEGER NOT NULL
      )
    ''');

    // Akun Kasir Default
    await db.insert(tableEmployees, {
      'name': 'Budi Kasir',
      'username': 'kasir1',
      'password': '123'
    });
    await db.insert(tableEmployees, {
      'name': 'Siti Kasir',
      'username': 'kasir2',
      'password': '123'
    });
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("DROP TABLE IF EXISTS $tableTransactions");
      await db.execute("DROP TABLE IF EXISTS $tableEmployees");
      await _onCreate(db, newVersion);
    }
  }

  // Auth: Cek Login
  Future<Employee?> login(String username, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      tableEmployees,
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) {
      return Employee.fromMap(maps.first);
    }
    return null;
  }

  // Query transaksi spesifik berdasarkan kasir
  Future<List<Map<String, dynamic>>> queryTransactionsByEmployee(int employeeId) async {
    Database db = await instance.database;
    return await db.query(
      tableTransactions,
      where: 'employee_id = ?',
      whereArgs: [employeeId],
      orderBy: "date DESC",
    );
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableTransactions, row);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(tableTransactions, where: 'id = ?', whereArgs: [id]);
  }// Menghitung urutan transaksi hari ini berdasarkan ID Kasir dan Tanggal
  Future<int> getTodayTransactionCount(int employeeId, String datePrefix) async {
    Database db = await instance.database;
    final result = await db.rawQuery(
      "SELECT COUNT(*) FROM $tableTransactions WHERE employee_id = ? AND date LIKE ?",
      [employeeId, '$datePrefix%']
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}