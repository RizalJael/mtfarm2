import '../models/mortal_mdl.dart';
import 'db_helper.dart';

class MortalDB {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertMortal(Mortal mortal) async {
    final db = await _databaseHelper.database;
    return await db.insert('mortal', mortal.toMap());
  }

  Future<List<Mortal>> getAllMortal() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT m.*, p.jenis, p.jkel
      FROM mortal m
      JOIN populasi p ON m.kode = p.kode
    ''');
    return List.generate(maps.length, (i) => Mortal.fromMap(maps[i]));
  }

  Future<Mortal?> getMortalById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT m.*, p.jenis, p.jkel
      FROM mortal m
      JOIN populasi p ON m.kode = p.kode
      WHERE m.id = ?
    ''', [id]);
    if (maps.isNotEmpty) {
      return Mortal.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Mortal>> getMortalByKode(String kode) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT m.*, p.jenis, p.jkel
      FROM mortal m
      JOIN populasi p ON m.kode = p.kode
      WHERE m.kode = ?
    ''', [kode]);
    return List.generate(maps.length, (i) => Mortal.fromMap(maps[i]));
  }

  Future<int> updateMortal(Mortal mortal) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'mortal',
      mortal.toMap(),
      where: 'id = ?',
      whereArgs: [mortal.id],
    );
  }

  Future<int> deleteMortal(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'mortal',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Mortal>> getMortalByDateRange(
      String startDate, String endDate) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT m.*, p.jenis, p.jkel
      FROM mortal m
      JOIN populasi p ON m.kode = p.kode
      WHERE m.tgl BETWEEN ? AND ?
    ''', [startDate, endDate]);
    return List.generate(maps.length, (i) => Mortal.fromMap(maps[i]));
  }

  Future<int> getTotalMortalByDateRange(
      String startDate, String endDate) async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as total
      FROM mortal
      WHERE tgl BETWEEN ? AND ?
    ''', [startDate, endDate]);
    return result.first['total'] as int? ?? 0;
  }
}
