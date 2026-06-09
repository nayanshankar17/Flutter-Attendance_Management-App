import 'package:sqflite/sqflite.dart';

//helps create proper database file paths
import 'package:path/path.dart';

class DatabaseHelper{
  static Database? _database; // only one database instance will exist in the whole app

  // Getter function to access the database
  // Future<Database> means: this function will return a Database object later
  Future<Database> get database async{
    //if a DB already exists, return the existing database  
    if(_database != null){
      return _database!;
    }

    //otherwise create/opean and return a new DB
    _database = await initDB();
    return _database!;
  }

  //intialize DB
  Future<Database> initDB() async{

    // getDatabasesPath() gives default database folder path
    // join() combines folder path + database filename
    String path = join(
      await getDatabasesPath(),
      'attendance.db',
    );

    //openDatabse(): Creates/opens SQLite DB
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await createTables(db);
      },
    );
  }

  // func to fetch data from database
  Future<List<Map<String,dynamic>>>
    getAttendance(String email) async {
      final db = await database;

      return await db.query(
        'attendance',
        where: 'email = ?',
        whereArgs: [email],
        orderBy: 'id DESC',
      );
    }
  

  //func to create tables 
  Future<void> createTables(Database db) async{

    //create table: SQL table creation query.
    //autoincriment: Automatically increases IDs.
    //email uniquely identifies user
    await db.execute('''
      CREATE TABLE attendance(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,
        date TEXT,
        status TEXT,
        punchIn TEXT,
        punchOut TEXT,
        workingHours TEXT
      )
    ''');
  } 

  // func to insert attendance record into database
  Future<Map<String, dynamic>?> getAttendanceByDate(String email, String date) async {
    final db = await database;
    final result = await db.query('attendance', where: 'email = ? AND date = ?', whereArgs: [email, date]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }


  // func to fetch attendance status for all dates for a user
  Future<List<Map<String,dynamic>>>  getAttendanceStatuses(String email,) async {
    final db = await database;
    return await db.query(
      'attendance',
      columns: [
        'date',
        'status',
      ],
      where: 'email = ?',
      whereArgs: [email],
    );
  }
  
  //============================
  //============================
  Future<void> clearAttendance(
    String email,
  ) async {

    final db = await database;

    await db.delete(
      'attendance',
      where: 'email = ?',
      whereArgs: [email],
    );
  }
  
}

