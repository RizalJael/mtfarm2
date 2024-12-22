import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/recent_activity_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mtfarm2.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE populasi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tgl TEXT,
        jenis TEXT,
        jkel TEXT,
        kode TEXT UNIQUE,
        induk TEXT,
        sumber TEXT,
        asal TEXT,
        keterangan TEXT,
        status TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE mortal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kode TEXT,
        tgl TEXT,
        penyebab TEXT,
        FOREIGN KEY (kode) REFERENCES populasi (kode)
      )
    ''');

    await db.execute('''
      CREATE TABLE potong (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kode TEXT,
        tgl TEXT,
        bobot INTEGER,
        tujuan TEXT,
        FOREIGN KEY (kode) REFERENCES populasi (kode)
      )
    ''');
  }

  // Metode umum untuk insert
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table, row);
  }

  // Metode umum untuk query
  Future<List<Map<String, dynamic>>> query(String table) async {
    Database db = await database;
    return await db.query(table);
  }

  // Metode umum untuk update
  Future<int> update(String table, Map<String, dynamic> row, String whereClause,
      List<dynamic> whereArgs) async {
    Database db = await database;
    return await db.update(table, row,
        where: whereClause, whereArgs: whereArgs);
  }

  // Metode umum untuk delete
  Future<int> delete(
      String table, String whereClause, List<dynamic> whereArgs) async {
    Database db = await database;
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

  Future<List<RecentActivity>> getRecentActivities() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT id, 'populasi' as type, kode as description, tgl as timestamp FROM populasi
    UNION ALL
    SELECT id, 'mortal' as type, kode as description, tgl as timestamp FROM mortal
    UNION ALL
    SELECT id, 'potong' as type, kode as description, tgl as timestamp FROM potong
    ORDER BY timestamp DESC
    LIMIT 10
  ''');

    return List.generate(maps.length, (i) {
      return RecentActivity.fromMap(maps[i]);
    });
  }
}
