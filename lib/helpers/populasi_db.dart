import 'package:sqflite/sqflite.dart';
import '../models/populasi_mdl.dart';
import 'db_helper.dart';
// import 'populasi_mdl.dart';

class PopulasiDB {
  final dbHelper = DatabaseHelper();

  Future<int> insertPopulasi(Populasi populasi) async {
    return await dbHelper.insert('populasi', populasi.toMap());
  }

  Future<List<Populasi>> getAllPopulasi() async {
    final List<Map<String, dynamic>> maps = await dbHelper.query('populasi');
    return List.generate(maps.length, (i) => Populasi.fromMap(maps[i]));
  }

  Future<int> updatePopulasi(Populasi populasi) async {
    return await dbHelper.update(
      'populasi',
      populasi.toMap(),
      'id = ?',
      [populasi.id],
    );
  }

  Future<int> deletePopulasi(int id) async {
    return await dbHelper.delete('populasi', 'id = ?', [id]);
  }

  Future<Populasi?> getPopulasiByKode(String kode) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> results = await db.query(
      'populasi',
      where: 'kode = ?',
      whereArgs: [kode],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return Populasi.fromMap(results.first);
    }
    return null;
  }

  Future<List<Populasi>> getPopulasiByJenis(String jenis) async {
    Database db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'populasi',
      where: 'jenis = ?',
      whereArgs: [jenis],
    );
    return List.generate(maps.length, (i) => Populasi.fromMap(maps[i]));
  }

  Future<List<Populasi>> getPopulasiByStatus(String status) async {
    Database db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'populasi',
      where: 'status = ?',
      whereArgs: [status],
    );
    return List.generate(maps.length, (i) => Populasi.fromMap(maps[i]));
  }

  // Tambahkan metode lain sesuai kebutuhan
}
