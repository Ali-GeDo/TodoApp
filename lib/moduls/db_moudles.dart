/*import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class DatabaseConnect
{
  Database? _database;
Future<Database> get database async
{
  var dbpath =await getDatabasesPath();
  const dbname = 'todo.db';
  final path = join(dbname ,dbname);

  //open the connction to database

  _database =await openDatabase(path ,version: 1 ,onCreate: _CreateDb);
  return _database!;

}

//the _create function creates table to our database
Future<void> _CreateDb(Database db , int virson)async
{
  await db.execute('''
  CREATE TABLE todo(
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  date TEXT,
  time TEXT
  )
   ''');
  print('Database created');
  print('table created');
}

//function to add to our database
Future<void> insertTodo(todo)async
{
  final db =await database;
  db.insert(
    'todo',
      todo.tomap(),
      conflictAlgorithm: ConflictAlgorithm.replace ,
  );
}
}

 */