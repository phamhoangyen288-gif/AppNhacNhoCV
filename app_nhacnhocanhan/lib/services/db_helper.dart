import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';
import '../models/goal.dart';
import '../models/reminders.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;


  DBHelper._init();

  /// 🔥 GET DATABASE
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  /// 🔥 INIT DB
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  /// 🔥 CREATE TABLE
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  description TEXT,
  startDate TEXT,
  endDate TEXT,
  status TEXT,
  priority TEXT,
  reminder TEXT
)
    ''');
    // 🔥 THÊM BẢNG goals Ở ĐÂY
    await db.execute('''
    CREATE TABLE goals(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      progress INTEGER
    )
  ''');

    //REMINDERS
    await db.execute('''
    CREATE TABLE reminders(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      taskId INTEGER,
      title TEXT,
      time TEXT,
      repeat TEXT,
      isOn INTEGER
    )
  ''');


  }

  /// 🔥 UPGRADE DB
  Future _onUpgrade(
      Database db,
      int oldVersion,
      int newVersion,
      ) async {

    if (oldVersion < 5) {

      await db.execute(
        "ALTER TABLE tasks ADD COLUMN startDate TEXT",
      );

      await db.execute(
        "ALTER TABLE tasks ADD COLUMN endDate TEXT",
      );

    }

    if (oldVersion < 4) {

      await db.execute(
        "ALTER TABLE tasks ADD COLUMN priority TEXT",
      );

      await db.execute(
        "ALTER TABLE tasks ADD COLUMN reminder TEXT",
      );

      await db.execute(
          "CREATE TABLE IF NOT EXISTS goals("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "title TEXT,"
              "progress INTEGER)"
      );

      await db.execute(
          "CREATE TABLE IF NOT EXISTS reminders("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "taskId INTEGER,"
              "title TEXT,"
              "time TEXT,"
              "repeat TEXT,"
              "isOn INTEGER)"
      );
    }
  }

  // ================= TASK =================
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final result = await db.query('tasks');
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future deleteTask(int id) async {
    final db = await database;
    await db.delete('tasks', where: 'id=?', whereArgs: [id]);
  }

  // ================= GOAL =================
  Future<List<Goal>> getGoals() async {
    final db = await database;
    final result = await db.query('goals');
    return result.map((e) => Goal.fromMap(e)).toList();
  }

  Future insertGoal(Goal goal) async {
    final db = await database;
    return await db.insert('goals', goal.toMap());
  }

  Future updateGoal(Goal goal) async {
    final db = await database;
    return await db.update(
      'goals',
      goal.toMap(),
      where: 'id=?',
      whereArgs: [goal.id],
    );
  }

  Future deleteGoal(int id) async {
    final db = await database;
    return await db.delete('goals', where: 'id=?', whereArgs: [id]);
  }


  // ============== REMINDERS ================
  Future<List<Reminder>> getReminders() async {
    final db = await database;

    final result = await db.query('reminders');

    return result.map((e) => Reminder.fromMap(e)).toList();
  }

  Future insertReminder(Reminder r) async {
    final db = await database;
    return await db.insert('reminders', r.toMap());
  }

  Future updateReminder(Reminder r) async {
    final db = await database;
    return await db.update(
      'reminders',
      r.toMap(),
      where: 'id=?',
      whereArgs: [r.id],
    );
  }

  Future deleteReminder(int id) async {
    final db = await database;
    return await db.delete('reminders', where: 'id=?', whereArgs: [id]);
  }
}




/*
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';
import '../models/goal.dart';


class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }




  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }



  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        date TEXT,
        status TEXT,
        priority TEXT,
        reminder TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE goals(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        progress INTEGER
      )     
    ''');
  }
//TASK
  Future<int> insertTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future updateTask(Task task) async {
    final db = await instance.database;
    await db.update('tasks', task.toMap(),
        where: 'id = ?', whereArgs: [task.id]);
  }

  Future deleteTask(int id) async {
    final db = await instance.database;
    await db.delete('tasks', where: 'id=?', whereArgs: [id]);
  }
}

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
    await db.execute("ALTER TABLE tasks ADD COLUMN priority TEXT");
    await db.execute("ALTER TABLE tasks ADD COLUMN reminder TEXT");
  }
}


//GOAL
Future<List<Goal>> getGoals() async {
  final db = await database;
  final result = await db.query('goals');
  return result.map((e) => Goal.fromMap(e)).toList();
}

Future insertGoal(Goal goal) async {
  final db = await database;
  return await db.insert('goals', goal.toMap());
}

Future updateGoal(Goal goal) async {
  final db = await database;
  return await db.update(
    'goals',
    goal.toMap(),
    where: 'id=?',
    whereArgs: [goal.id],
  );
}

Future deleteGoal(int id) async {
  final db = await database;
  return await db.delete('goals', where: 'id=?', whereArgs: [id]);
}
*/