// FILEPATH: /d:/flutter_pro/mtfarm2/mtfarm2/lib/helpers/recent_activity_db.dart

import 'package:sqflite/sqflite.dart';
import '../models/recent_activity_model.dart';
import 'db_helper.dart';

class RecentActivityDb {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<List<RecentActivity>> getRecentActivities() async {
    final db = await dbHelper.database;
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

  Future<int> getPopulasiCount() async {
    final db = await dbHelper.database;
    return Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM populasi')) ??
        0;
  }

  Future<int> getMortalCount() async {
    final db = await dbHelper.database;
    return Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM mortal')) ??
        0;
  }

  Future<int> getPotongCount() async {
    final db = await dbHelper.database;
    return Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM potong')) ??
        0;
  }
}
