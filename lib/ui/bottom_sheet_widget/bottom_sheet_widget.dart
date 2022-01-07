import 'package:flutter/material.dart';

const ShapeBorder bottomSheetShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(15), right: Radius.circular(15)));

initState() {
  getData();
}

getData() {
  List<Product> yellowDiamond = [];
  List<Product> hoppins = [];
  yellowDiamond.add(Product(
      productName: "YD Namkeen Ring Toma- to 13 gm 210 pkt Rs. 5 -With Race Toys",
      mrp: "5.00",
      ptr: "4.32 |4.16",
      moqQty: 1,
      boxQty: 1,
      total: "49.32",
      brand: "Yellow Diamond"));

  yellowDiamond.add(Product(
      productName: "YD Namkeen Mixture 24gm 360 pkt Rs 5",
      mrp: "5.25",
      ptr: "4.10",
      moqQty: 2,
      boxQty: 0,
      total: "35.00",
      brand: "Yellow Diamond"));
  yellowDiamond.add(Product(
      productName: "RF Cup Cake Chocolate 18 gm 160 pkt Rs 5",
      mrp: "6.00",
      ptr: "5.00",
      moqQty: 1,
      boxQty: 1,
      total: "90.00",
      brand: "Yellow Diamond"));

  hoppins.add(Product(
      productName: "HO Glow Pop Animal Rs 5", mrp: "8.00", ptr: "7.50", moqQty: 4, boxQty: 3, total: "108.00", brand: "Hoppin"));
  hoppins.add(Product(
      productName: "1 HO Glow Pop Duckling Rs 5", mrp: "5.00", ptr: "4.00", moqQty: 2, boxQty: 2, total: "75.27", brand: "Hoppin"));

  SummeryData summeryData = SummeryData(yellowDiamond: yellowDiamond, hoppins: hoppins);
}

class SummeryData {
  List<Product> yellowDiamond;
  List<Product> hoppins;

  SummeryData({required this.yellowDiamond, required this.hoppins});
}

class Product {
  String productName;
  String mrp;
  String ptr;
  int moqQty;
  int boxQty;
  String total;
  String brand;

  Product(
      {required this.productName,
      required this.mrp,
      required this.ptr,
      required this.moqQty,
      required this.boxQty,
      required this.total,
      required this.brand});
}
