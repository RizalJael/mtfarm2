import '../models/potong_mdl.dart';
import 'db_helper.dart';

class PotongDB {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertPotong(Potong potong) async {
    final db = await _databaseHelper.database;
    return await db.insert('potong', potong.toMap());
  }

  Future<List<Potong>> getAllPotongWithPopulasi() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.*, pop.jenis, pop.jkel
      FROM potong p
      JOIN populasi pop ON p.kode = pop.kode
    ''');
    return List.generate(maps.length, (i) => Potong.fromMap(maps[i]));
  }

  Future<Potong?> getPotongByIdWithPopulasi(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.*, pop.jenis, pop.jkel
      FROM potong p
      JOIN populasi pop ON p.kode = pop.kode
      WHERE p.id = ?
    ''', [id]);
    if (maps.isNotEmpty) {
      return Potong.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Potong>> getPotongByKode(String kode) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.*, pop.jenis, pop.jkel
      FROM potong p
      JOIN populasi pop ON p.kode = pop.kode
      WHERE p.kode = ?
    ''', [kode]);
    return List.generate(maps.length, (i) => Potong.fromMap(maps[i]));
  }

  Future<int> updatePotong(Potong potong) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'potong',
      potong.toMap(),
      where: 'id = ?',
      whereArgs: [potong.id],
    );
  }

  Future<int> deletePotong(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'potong',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Potong>> getPotongByDateRange(
      String startDate, String endDate) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.*, pop.jenis, pop.jkel
      FROM potong p
      JOIN populasi pop ON p.kode = pop.kode
      WHERE p.tgl BETWEEN ? AND ?
    ''', [startDate, endDate]);
    return List.generate(maps.length, (i) => Potong.fromMap(maps[i]));
  }

  Future<double> getTotalBobotByDateRange(
      String startDate, String endDate) async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('''
      SELECT SUM(bobot) as total
      FROM potong
      WHERE tgl BETWEEN ? AND ?
    ''', [startDate, endDate]);
    return result.first['total'] as double? ?? 0.0;
  }
}
