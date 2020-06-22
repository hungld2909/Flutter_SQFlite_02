import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = "todo";
final String Column_id = "id";
final String Column_name = "name";

class TaskModel {
  final String name;
  final int id;
  TaskModel({this.name, this.id});

  Map<String, dynamic> toMap() {
    return {
      Column_name: this.name,
      Column_id: this.id
    };
  }
}

class TodoHelper {
  Database db;
  TodoHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), "databse.db"),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE $tableName($Column_id INTEGER PRIMARY KEY AUTOINCREMENT, $Column_name TEXT)");
      },
      version: 1,
    );
  }

  Future<void> insertTask(TaskModel task) async {
    try {
      db.insert(
        tableName,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<List<TaskModel>> getAllTask() async {
    final List<Map<String, dynamic>> tasks = await db.query(tableName);

    return List.generate(tasks.length, (i) {
      return TaskModel(
        name: tasks[i][Column_name],
        id: tasks[i][Column_id],
      );
    });
  }

  Future<int> deleteTask(int id) async {
    int result =
        await db.rawDelete('DELETE FROM $tableName WHERE $Column_id = $id');
    return result;
  }
}
