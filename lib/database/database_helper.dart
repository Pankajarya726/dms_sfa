import 'package:dms/database/db_constant.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper db = DatabaseHelper.internal();

  DatabaseHelper.internal();

  factory DatabaseHelper() {
    return db;
  }

  static Database? database;

  static Future<Database> getDatabase() async {
    database ??= await initDB();
    return database!;
  }

  //init data base
  static initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, DBConstant.dbName);
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute(DBConstant.createCartTable);
    });
  }

  //Clear database
  clearDatabase() async {
    debugPrint("clearDatabase---->");

    try {
      final db = await getDatabase();
      //here we execute a query to drop the table if exists which is called "tableName"
      //and could be given as method's input parameter too
      await db.execute("DROP TABLE IF EXISTS " + DBConstant.cartTable);
      await db.execute(DBConstant.createCartTable);
    } catch (error) {
      debugPrint("error---->$error");
      // throw Exception('DatabaseHelper.clearDatabase: ' + error.toString());
    }
  }

  Future<int> clearCart() async {
    debugPrint("clearCart---->");
    int i = 0;
    try {
      final db = await getDatabase();

      int i = await db.rawDelete(DBConstant.cartTable);
      return i;
    } catch (error) {
      debugPrint("error---->$error");
      return i;
    }
  }

  Future<int> addProductToCart(Cart cart) async {
    debugPrint('addProductToCart--->$cart');
    int i = 0;
    try {
      final db = await getDatabase();

      Cart? mCart = await searchProductFromCart(cart.productId);
      if (mCart == null) {
        i = await db.insert(DBConstant.cartTable, cart.toMap());
      } else {
        i = await updateCart(cart);
      }

      return i;
    } catch (error) {
      debugPrint("error---->$error");
      return i;
    }
  }

  Future<List<Cart>> getCart() async {
    debugPrint('getCart--->');
    List<Cart> cart = [];

    try {
      final db = await getDatabase();
      String query = "SELECT * FROM ${DBConstant.cartTable} ";
      List<Map<String, dynamic>> result = await db.query(
        DBConstant.cartTable,
      );

      Future.forEach(result, (Map<String, dynamic> data) {
        debugPrint("cart-item--->$data");
        cart.add(Cart.fromMap(data));
      });

      return cart;
    } catch (error) {
      debugPrint("error---->$error");
      return cart;
    }
  }

  Future<List<BrandWiseCart>> getCartBrandWise() async {
    debugPrint('getCart--->');
    List<BrandWiseCart> brands = [];

    try {
      final db = await getDatabase();
      List<String> brand = await getBrand();

      await Future.forEach(brand, (String brand) async {
        debugPrint("brand--->$brand");
        List<Map<String, dynamic>> result =
            await db.query(DBConstant.cartTable, where: DBConstant.brandId + " = ?", whereArgs: [brand]);
        debugPrint('result--->$result');

        String moq = "0";
        String pkg = "0";
        String total = "0";

        String moqSumQuery =
            "SELECT SUM(${DBConstant.moqQty}) AS total_moq_qty, SUM(${DBConstant.pkgOty}) AS total_pkg_qty, (SUM(${DBConstant.pkgOty}*${DBConstant.skuRatePerPkg})+SUM(${DBConstant.moqQty}*${DBConstant.skuRatePerMoq})) AS total_amount FROM ${DBConstant.cartTable} WHERE ${DBConstant.brandId} = $brand";
        List<Map<String, dynamic>> sum = await db.rawQuery(moqSumQuery);
        debugPrint('sum--->$sum');

        if (sum.isNotEmpty) {
          moq = sum.first["total_moq_qty"].toString();
          pkg = sum.first["total_pkg_qty"].toString();
          total = sum.first["total_amount"].toString();
        }

        if (result.isNotEmpty) {
          Map<String, dynamic> map = {
            "brand_id": brand,
            "brand_name": result.first["brand_name"],
            "total_moq_qty": moq,
            "total_pkg_qty": pkg,
            "total_amount": total,
            "cart": result,
          };
          BrandWiseCart brandWiseCart = BrandWiseCart.fromMap(map);
          brands.add(brandWiseCart);
        }
      });

      return brands;
    } catch (error) {
      debugPrint("error---->$error");
      return brands;
    }
  }

  Future<List<String>> getBrand() async {
    debugPrint('getBrand--->');
    List<String> brand = [];

    try {
      final db = await getDatabase();
      List<Map<String, dynamic>> result =
          await db.query(DBConstant.cartTable, columns: [DBConstant.brandId, DBConstant.brandName], groupBy: DBConstant.brandId);

      Future.forEach(result, (Map<String, dynamic> data) {
        debugPrint("brand--->$data");
        brand.add(data[DBConstant.brandId]);
      });

      return brand;
    } catch (error) {
      debugPrint("error---->$error");
      return brand;
    }
  }

  Future<Cart?> searchProductFromCart(String productId) async {
    debugPrint('searchProductFromCart--->$productId');
    Cart? cart;

    try {
      final db = await getDatabase();

      List<Map<String, dynamic>> result =
          await db.query(DBConstant.cartTable, where: DBConstant.productId + " = ?", whereArgs: [productId]);
      debugPrint('result--->$result');
      if (result.isNotEmpty) {
        return cart = Cart.fromMap(result.first);
      }

      return cart;
    } catch (error) {
      debugPrint("error---->$error");
      return cart;
    }
  }

  Future<int> updateCart(Cart cart) async {
    debugPrint('updateCart--->$cart');
    int i = 0;
    try {
      final db = await getDatabase();
      int i = await db.update(DBConstant.cartTable, cart.toMap(), where: DBConstant.productId + " = ?", whereArgs: [cart.productId]);
      return i;
    } catch (error) {
      debugPrint("error---->$error");
      return i;
    }
  }

  Future<int> deleteProductFromCart(String productId) async {
    debugPrint('deleteProductFromCart--->$productId');
    int i = 0;
    try {
      final db = await getDatabase();
      int i = await db.delete(DBConstant.cartTable, where: DBConstant.productId + " = ?", whereArgs: [productId]);
      return i;
    } catch (error) {
      debugPrint("error---->$error");
      return i;
    }
  }
}
