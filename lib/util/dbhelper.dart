// Database access layer and helper functions
import 'dart:io';
import 'package:docExpiry/model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  

  String docExpiration = 'expiration';
// Fields of the 'docs' table
  String docId = 'id';

  String docTitle = 'title';
  String fqHalfYear = 'fqHalfYear';
  String fqMonth = 'fqMonth';
  String fqQuarter = 'fqQuarter';
  String fqYear = 'fqYear';
// Tables
  static String tblDocs = "docs";

// Single reference to the database
// Database entry point
  static Database _db;

// Singleton
  static final DbHelper _dbHelper = DbHelper._internal();

// Factory constructor
factory DbHelper(){
  return _dbHelper;
}
  DbHelper._internal();

// Get runtime refernce to the database and initialization
  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  // Intitalize the database(opens database and creates it if it doesnt exist)
  Future<Database> initializeDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = documentDirectory.path + "/docexpiry.db";
    var db = await openDatabase(path, version: 1, onCreate: _createDb);
    return db;
  }

  // create database table
  void _createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tblDocs($docId INTEGER PRIMARY KEY, $docTitle TEXT, " +
            "$docExpiration TEXT, " +
            "$fqYear INTEGER, $fqHalfYear INTEGER, $fqQuarter INTEGER, " +
            "$fqMonth INTEGER)");
  }

  // Insert a new document
  Future<int> insertDoc(Doc doc) async {
    var insertQuery;
    // reads reference to the database
    Database database = await this.db;
    try {
      insertQuery = await database.insert(tblDocs, doc.toMap());
    } catch (e) {
      debugPrint("InsertDoc: " + e.toString());
    }
    return insertQuery;
  }

  // Get the list of docs
  Future<List> getDocs() async {
    Database database = await this.db;
    var selectQuery = await database
        .rawQuery("SELECT * FROM $tblDocs ORDER BY $docExpiration ASC");
    return selectQuery;
  }

  // Get a doc based on the id
  Future<List> getDoc(int id) async {
    Database database = await this.db;
    var selectQuery = await database.rawQuery(
        "SELECT * FROM $tblDocs WHERE $docId = " + id.toString() + "");
    return selectQuery;
  }

  // Get a doc based on a String payload (id and expiration date)
  Future<List> getDocFromStr(String payload) async {
    List<String> p = payload.split("|");
    if (p.length == 2) {
      Database database = await this.db;
      var selectQuery = await database.rawQuery(
          "SELECT * FROM $tblDocs WHERE $docId = " +
              p[0] +
              " AND $docExpiration = '" +
              p[1] +
              "' ");
      return selectQuery;
    } else {
      return null;
    }
  }

  // Get the number of docs
  Future<int> getDocsCount() async {
    Database database = await this.db;
    var docCount = Sqflite.firstIntValue(
        await database.rawQuery("SELECT COUNT(*) FROM $tblDocs"));
    return docCount;
  }

  // Get the max document id available on the database
  Future<int> getMaxId() async {
    Database database = await this.db;
    var maxId = Sqflite.firstIntValue(
        await database.rawQuery("SELECT MAX(id) FROM $tblDocs"));
    return maxId;
  }

  // Update a doc
  Future<int> updateDoc(Doc doc) async {
    var database = await this.db;
    var updateQuery = await database
        .update(tblDocs, doc.toMap(), where: "$docId = ?", 
        whereArgs: [doc.id]);
    return updateQuery;
  }

  // Delete a doc
  Future<int> deleteDoc(int id) async {
    var database = await this.db;
    int deleteQuery =
        await database.rawDelete("DELETE FROM $tblDocs WHERE $docId = $id");
    return deleteQuery;
  }

  // Delete all docs
  Future<int> deleteRows(String tbl) async {
    var database = await this.db;
    int deleteRowsQuery = await database.rawDelete("DELETE FROM $tbl");
    return deleteRowsQuery;
  }
}
