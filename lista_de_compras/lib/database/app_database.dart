import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

Map<int, String> scripts = {
  1: ''' CREATE TABLE cartlist (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          description TEXT
          );''',
  2: ''' CREATE TABLE productlist (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          listid INTEGER,
          listName TEXT,          
          name TEXT,          
          price INTEGER,          
          unity TEXT,          
          amount INTEGER,          
          checked INTEGER          
          );''',
  
};

class ListaDeComprasDataBase {
  static Database? db;

  Future<Database> getDatabase() async {
    if (db == null) {
      return await startDatabase();
    } else {
      return db!;
    }
  }

  Future<Database> startDatabase() async {
    var db = await openDatabase(
        path.join(await getDatabasesPath(), 'database.db'),
        version: scripts.length, onCreate: (Database db, int version) async {
      for (var i = 1; i <= scripts.length; i++) {
        await db.execute(scripts[i]!);
      }
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (var i = oldVersion + 1; i <= scripts.length; i++) {
        await db.execute(scripts[i]!);
      }
    });
    return db;
  }
}
