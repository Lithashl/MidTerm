import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/rating.dart';

class RatingDatabase {
  static final RatingDatabase instance = RatingDatabase._init();

  static Database? _database;

  RatingDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('rating.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableRating ( 
  ${RatingFields.id} $idType, 
  ${RatingFields.isImportant} $boolType,
  ${RatingFields.number} $integerType,
  ${RatingFields.title} $textType,
  ${RatingFields.description} $textType,
  ${RatingFields.time} $textType
  )
''');
  }

  Future<Rating> create(Rating rating) async {
    final db = await instance.database;


    final id = await db.insert(tableRating, rating.toJson());
    return rating.copy(id: id);
  }

  Future<Rating> readRating(int id) async { //read note where id, only select one data
    final db = await instance.database;

    final maps = await db.query(
      tableRating,
      columns: RatingFields.values,
      where: '${RatingFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Rating.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Rating>> readAllRating() async { //select all data
    final db = await instance.database;

    final orderBy = '${RatingFields.time} ASC'; //ASC=oldest on top


    final result = await db.query(tableRating, orderBy: orderBy);

    return result.map((json) => Rating.fromJson(json)).toList();
  }

  Future<int> update(Rating note) async {
    final db = await instance.database;

    return db.update(
      tableRating,
      note.toJson(),
      where: '${RatingFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableRating,
      where: '${RatingFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}