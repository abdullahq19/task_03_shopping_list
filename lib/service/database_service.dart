import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_03_shopping_list_app/model/item.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();
  Database? _db;

  Future<Database> get database async {
    return _db ??=
        await openDatabase(join(await getDatabasesPath(), 'shopping.db'),
            onCreate: (db, version) async {
      await db.execute(Item.CREATE_TABLE);
    }, version: 1);
  }

  Future<bool> insertItem(Item item) async {
    try {
      var db = await database;
      int rowId = await db.insert(Item.tableName, item.toMap());
      if (rowId > 0) {
        item.id = rowId;
      }
      return rowId > 0;
    } catch (e) {
      log('Item Insertion Error: ${e.toString()}');
      return false;
    }
  }

  Future<bool> deleteItem(Item item) async {
    try {
      var db = await database;
      int rowId = await db
          .delete(Item.tableName, where: 'id = ?', whereArgs: [item.id]);
      return rowId > 0;
    } catch (e) {
      log('Item Deletion Error: ${e.toString()}');
      return false;
    }
  }

  Future<List<Item>> getItems() async {
    try {
      var db = await database;
      List<Map<String, dynamic>> dbResponse = await db.query(Item.tableName);
      return dbResponse.map((item) => Item.fromMap(item)).toList();
    } catch (e) {
      log('Items Fetching Error: ${e.toString()}');
      return [];
    }
  }
}
