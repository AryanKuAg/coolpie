import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabase {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.dn in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE LocalSavedValue(id INTEGER PRIMARY KEY, value TEXT, image TEXT)");
    print("Created tables");
  }

  // Retrieving employees from Employee Tables
  Future<List<LocalSavedValue>> getLocalSavedValue() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM LocalSavedValue');
    List<LocalSavedValue> localSavedValue = new List();
    for (int i = 0; i < list.length; i++) {
      localSavedValue.add(new LocalSavedValue(
        value: list[i]["value"],
        image: list[i]["image"],
      ));
    }
    print(localSavedValue.length);
    return localSavedValue;
  }

  void saveLocalSavedValue(LocalSavedValue localSavedValue) async {
    String value =
        localSavedValue.value.replaceAll('\"', ' ').replaceAll('\'', ' ');
    print(value);
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          "INSERT INTO LocalSavedValue(value, image ) VALUES(" +
              "\'" +
              value +
              "\'" +
              ',' +
              '\'' +
              localSavedValue.image +
              '\'' +
              ')');
    });
  }
}

class LocalSavedValue {
  final String image;
  final String value;

  LocalSavedValue({@required this.image, @required this.value});
}
