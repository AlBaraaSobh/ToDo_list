import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/model/Task.dart';

class DbHelper {
  static DbHelper dbHelper = DbHelper._();
  final String TaskTable = "TaskTable";
  final String columnId = "id";
  final String columnTitle = "title";
  final String columnDetails = "Details";
  final String columnStatus = "status";


  DbHelper._();
  late Database database;

  initDatabase() async {
    database = await createDatabase();
  }

  Future<Database> createDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String directoryPath = directory.path;
    String databasePath = directoryPath + 'Task.db';
    Database database =
    await openDatabase(databasePath, version: 1, onCreate: (db, v) {

      db.execute("CREATE TABLE $TaskTable($columnId INTEGER PRIMARY KEY autoincrement ,"
          " $columnTitle TEXT, $columnDetails TEXT ,$columnStatus INTEGER )");

    });
    return database;
  }

  insertTask(Task task) async {
    int x = await database.insert(TaskTable, task.toMap());
  }

  Future<List<Map<String, Object?>>> getAllTask() async {
    List<Map<String, Object?>> maps = await database.query(TaskTable);
    return maps;
  }

  deleteTask(int id) async {
    int x = await database
        .delete(TaskTable, where: 'id=?', whereArgs: [id]);
    print(x);
  }
  Future<bool> updateTask(Task task) async {
    try {
      await database.update(TaskTable, task.toMap(),
          where: '$columnId=?', whereArgs: [task.id]);
      return true;
    } on Exception catch (e) {
      return false;
    }
  }


  }