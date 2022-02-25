import 'package:notas_isadata/sqlite/modelo/nota.dart';
import 'package:notas_isadata/sqlite/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

// ignore: camel_case_types
class SQLite_Insertar {
  Future<void> nota(Nota nota) async {
    final Database? db = await SQLiteHelper.getDB();
    await db!.insert(
      'notas',
      nota.toMap(),
    );
  }
}
