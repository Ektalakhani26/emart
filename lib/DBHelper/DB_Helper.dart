

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    print('************************************');
    await database.execute("""CREATE TABLE Product(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        Name TEXT,
        Description TEXT,
        Price TEXT,
        Discount TEXT,
        size TEXT,
        qty INTEGER,
        image TEXT
      )
      """);
    print('table product created');
    await database.execute("""CREATE TABLE favorite(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        subtitle TEXT,
        price TEXT,
        description TEXT,
        image TEXT
      )
      """);
    print('table favrite created');
    await database.execute("""CREATE TABLE profile(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        contact TEXT,
        email TEXT,
        pincode TEXT,
        city TEXT,
        state TEXT,
        image TEXT
      )
      """);
  }


  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'kindacode.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
       // await Favoritetable(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String title,String subtitle,String price,String discount, String size,int qty,String fileimage) async {
    final db = await SQLHelper.db();
    final data = {'Name': title,'Description' : subtitle,'Price' : price ,'Discount' : discount,'size' : size,'qty' : qty,'image' : fileimage};
    final id = await db.insert('Product', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //favorite item create

  static Future<int> favoriteItem(String title,String subtitle,String price, String descrption,String fileimage) async {
    final db = await SQLHelper.db();
    final data = {'title': title,'subtitle' : subtitle,'price' : price ,'description': descrption, 'image' : fileimage};
    final id = await db.insert('favorite', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }
//profile item create
  static Future<int> profileItem(String name,String contact,String email,String pincode, String city, String state,String fileImg) async {
    final db = await SQLHelper.db();

    final data = {'name': name,'contact': contact,'email' : email,'pincode':pincode ,'city': city,'state' : state, 'image': fileImg};
    final id = await db.insert('profile', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }
  // Read all Product (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('Product', orderBy: "id");
  }

  //  getitems from favorite
  static Future<List<Map<String, dynamic>>> favoritegetItems() async {
    final db = await SQLHelper.db();
    return db.query('favorite', orderBy: "id");
  }
// get item from profile
  static Future<List<Map<String, dynamic>>> getprofileItems() async {
    final db = await SQLHelper.db();
    return db.query('profile', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('Product', where: "id = ?", whereArgs: [id], limit: 1);
  }
  // favoritegetitem
  static Future<List<Map<String, dynamic>>> favoritegetItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('favorite', where: "id = ?", whereArgs: [id], limit: 1);
  }

// read single profile item
  static Future<List<Map<String, dynamic>>> getprofileItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('profile', where: "id = ?", whereArgs: [id], limit: 1);
  }

  //update item in profile
  static Future<int> updateItem(
      int id, String name,String contact,String email,String pincode, String city, String state,String fileImg) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'contact': contact,
      'email' : email,
      'pincode':pincode ,
      'city': city,
      'state' : state,
      'image': fileImg
    };

    final result =
    await db.update('profile', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("Product", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
// delete favorite item
  static Future<void> favoritedeleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("favorite", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
  // delete profile
  static Future<void> deleteprofileItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("profile", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}