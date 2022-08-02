import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DBHelper {

  static final DBHelper instance = new DBHelper.internal();

  factory DBHelper() => instance;
  static Database db;

  Future<Database> get sqflite async {
    
    if (db != null) return db;
    db = await initDb();
    return db;
    
  }

  DBHelper.internal();

  initDb() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String dbPath = join(documentsDirectory.path, 'memovie.db');
    var theDb = await openDatabase(dbPath, version: 1, onCreate: onCreateTable);
    
    return theDb;

  }

  onCreateTable(Database db, int version) async {
    await db.execute('CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, pass TEXT)');
    await db.execute('CREATE TABLE favorite (id INTEGER PRIMARY KEY AUTOINCREMENT, idmovie INTEGER, iduser INTEGER, poster_path TEXT, backdrop_path TEXT, title TEXT, genre_ids TEXT, vote_average TEXT, vote_count TEXT, popularity TEXT, overview TEXT, adult INTEGER, FOREIGN KEY(iduser) REFERENCES user(id))');
  }

  Future<int> saveUser({@required dynamic user}) async {

    final dbClient = await DBHelper().sqflite;
    int res = await dbClient.insert('user', user);
    return res;

  }

  Future<dynamic> getUserWhereEmail({@required String email}) async {

    var dbClient = await DBHelper().sqflite;
    List<Map> users = await dbClient.query('user', where: 'email = ?', whereArgs: [email]);

    var result = jsonEncode(users);
    return result;

  }

  Future updateUser({@required int idUser, @required dynamic newData}) async {

    var dbClient = await DBHelper().sqflite;
    var res = await dbClient.update('user', newData, where: 'id = ?', whereArgs: [idUser]);
    
    return res;

  }

  Future<dynamic> getAllFavoriteMovie({@required int idUser}) async {

    var dbClient = await DBHelper().sqflite;
    List<Map> movies = await dbClient.query('favorite', where: 'iduser = ?', whereArgs: [idUser]);

    var result = jsonEncode(movies);
    return result;

  }

  Future<int> saveFavoriteMovie({@required dynamic movie,}) async {

    final dbClient = await DBHelper().sqflite;
    int res = await dbClient.insert('favorite', movie, conflictAlgorithm: ConflictAlgorithm.ignore);
    return res;

  }

  Future deleteFavoriteMovie({@required int id}) async {

    var dbClient = await DBHelper().sqflite;
    var res = await dbClient.delete('favorite', where: 'id = ?', whereArgs: [id]);

    return res;

  }

}