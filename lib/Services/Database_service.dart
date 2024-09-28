


import 'package:offlinedatabase/utility/Contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
    static final DatabaseService instance = DatabaseService._constractor();
    
   final String _tablename = "info_table";
    
   final String _id = "id";
   final String _name = "name";
   final String _phone = "phone";

    DatabaseService._constractor();

     Future<Database> get database  async {
     if(_db!=null) return _db!;
     _db = await getDatabase();
     return _db!;
    }
     
        
     Future<Database> getDatabase () async {
      final dbdirpath = await getDatabasesPath();
       final path = join(dbdirpath, "info.db");
     
      final database =  await openDatabase(
        path,
        version: 1,
        onCreate: (db, version){
           db.execute(
            '''CREATE TABLE $_tablename(
            $_id INTEGER PRIMARY KEY AUTOINCREMENT,
            $_name TEXT, 
            $_phone TEXT
             )'''
          );
     
        } ,
      );
      return database;
    }////database setup

    void AddContact (String inputename , String inputenumber)async{
      final db = await database;
      db.insert(_tablename, {
        _name : inputename,
        _phone : inputenumber,
      });

    }
    Future<List<Contact>> getContact() async {
  final db = await database;
  final data = await db.query(_tablename);
  List<Contact> datalist = data.map(
    (e) => Contact(
      id: e['id'] as int,
      name: e['name'] as String,
      phone: e['phone'].toString()  // Convert phone to string if it's an int
    )
  ).toList();
  print(datalist.toString());
  return datalist;
}

 void  getremove (int id) async {
  final db = await database;
  await db.delete(
    _tablename ,
    where: '$_id = ? ' ,
    whereArgs: [id],
    );
  
 }
 void addContactWithID(Contact contact) async {
  final db = await database;
  await db.insert(_tablename, contact.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
}



}