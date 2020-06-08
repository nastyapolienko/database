import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:adddatadb/ClientModel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "library.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Book ("
              "id INTEGER PRIMARY KEY,"
              "bookname TEXT"
              ")");
        });
  }

  newBook(Book newBook) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Book");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into Book (id,bookname)"
            " VALUES (?,?)",
        [id, newBook.bookname]);
    return raw;
  }


  updateBook(Book newBook) async {
    final db = await database;
    var res = await db.update("Book", newBook.toMap(),
        where: "id = ?", whereArgs: [newBook.id]);
    return res;
  }

  getBook(int id) async {
    final db = await database;
    var res = await db.query("Book", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Book.fromMap(res.first) : null;
  }

  Future<List<Book>> getAllBooks() async {
    final db = await database;
    var res = await db.query("Book");
    List<Book> list =
    res.isNotEmpty ? res.map((c) => Book.fromMap(c)).toList() : [];
    return list;
  }

  deleteBook(int id) async {
    final db = await database;
    return db.delete("Book", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Book");
  }
}