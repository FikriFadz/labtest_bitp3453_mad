import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BMIDatabase {
  static Database? _database;
  static final String _databaseName = 'bitp3453_bmi.db';
  static final String _tableName = 'bmi';

  static final String columnUsername = 'username';
  static final String columnWeight = 'weight';
  static final String columnHeight = 'height';
  static final String columnGender = 'gender';
  static final String columnBMIStatus = 'bmi_status';

  BMIDatabase._privateConstructor();
  static final BMIDatabase instance = BMIDatabase._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY,
            $columnUsername TEXT,
            $columnWeight TEXT,
            $columnHeight TEXT,
            $columnGender TEXT,
            $columnBMIStatus TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertData({
    required String username,
    required String weight,
    required String height,
    required String gender,
    required String bmiStatus,
  }) async {
    final db = await database;
    await db.insert(
      _tableName,
      {
        columnUsername: username,
        columnWeight: weight,
        columnHeight: height,
        columnGender: gender,
        columnBMIStatus: bmiStatus,
      },
    );
    print('$username with weight $weight kg and height $height cm and gender $gender and bmistatus $bmiStatus added to the database successfully');
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await database;
    return await db.query(_tableName);
  }
}
