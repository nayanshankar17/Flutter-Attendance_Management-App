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
    getAttendance() async {
      final db = await database;

      return await db.query(
        'attendance',
        orderBy: 'id DESC',
      );
    }
  

  //func to create tables 
  Future<void> createTables(Database db) async{

    //create table: SQL table creation query.
    //autoincriment: Automatically increases IDs.
    await db.execute('''
      CREATE TABLE attendance(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        status TEXT,
        punchIn TEXT,
        punchOut TEXT,
        workingHours TEXT
      )
    ''');
  } 
}

