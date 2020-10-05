import 'package:sqflite/sqflite.dart';
import 'dart:async';

class Task {
  int id;
  String name;
  bool completed;
  Task(this.id, this.name, this.completed);
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "completed": completed ? 1 : 0
    };
  }

  Task.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    completed = map['completed'] == 1;
    id = map['id'];
  }

}

class TaskDatabase {
  Database _db;

  Future initDB() async {
    if (_db!=null) {
      return;
    }

    _db = await openDatabase(
      'my_db.db',
      version: 6,
      onCreate: (Database db, int version) {
        db.execute("CREATE TABLE tasks (id INTEGER PRIMARY KEY, name TEXT NOT NULL, completed INTEGER DEFAULT 0);");
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) {
        if ((oldVersion < 2) && (newVersion <= 6)) {
          db.execute("ALTER TABLE task ADD COLUMN completed INTEGER DEFAULT 0;");
        }
      }
    );
    print("DB Inizialized");
  }

  insert(Task task) async {
    _db.insert("tasks", task.toMap());
  }

  Future<List<Task>> getAllTasks() async {
    List <Map<String, dynamic>> results = await _db.query("tasks");

    return results.map((map) => Task.fromMap(map)).toList();
  }

  Future updateTask(Task task) async {
    _db.update("tasks", task.toMap(), where: "id = ?", whereArgs: [task.id]);
  }

}