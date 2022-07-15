import 'dart:convert';

import 'package:intl/intl.dart';

class RetailersDetailsResponse {
  RetailersDetailsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<RetailerDetailsModal> data;

  factory RetailersDetailsResponse.fromJson(String str) => RetailersDetailsResponse.fromMap(json.decode(str));

  factory RetailersDetailsResponse.fromMap(Map<String, dynamic> json) => RetailersDetailsResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? [] : List<RetailerDetailsModal>.from(json["data"].map((x) => RetailerDetailsModal.fromMap(x))),
      );
}

class RetailerDetailsModal {
  RetailerDetailsModal({
    required this.customerId,
    required this.userId,
    required this.uniqueCode,
    required this.customerName,
    required this.outlatName,
    required this.districtId,
    required this.beatId,
    required this.beatName,
    required this.primaryAddress,
    required this.lat,
    required this.lng,
    required this.enrollmentTypeId,
    required this.primaryMobile,
    required this.secondaryMobile,
    required this.orderBookingDay,
    required this.connectionStatus,
    required this.remark,
    required this.potential,
    required this.outletPicture,
    required this.tcStatus,
    required this.pendingTask,
    required this.lastVisit,
    required this.orderHistory,
  });

  String customerId;
  String userId;
  String uniqueCode;
  String customerName;
  String outlatName;
  String districtId;
  String beatId;
  String beatName;
  String primaryAddress;
  String lat;
  String lng;
  String enrollmentTypeId;
  String primaryMobile;
  String secondaryMobile;
  String orderBookingDay;
  String connectionStatus;
  String remark;
  String potential;
  String outletPicture;
  String tcStatus;
  String pendingTask;
  LastVisit? lastVisit;
  List<LastVisit> orderHistory;

  factory RetailerDetailsModal.fromJson(String str) => RetailerDetailsModal.fromMap(json.decode(str));

  factory RetailerDetailsModal.fromMap(Map<String, dynamic> json) => RetailerDetailsModal(
        customerId: json["customer_id"] == null ? "" : json["customer_id"].toString(),
        userId: json["user_id"] == null ? "" : json["user_id"].toString(),
        uniqueCode: json["unique_code"] == null ? "" : json["unique_code"].toString(),
        customerName: json["customer_name"] == null ? "" : json["customer_name"].toString(),
        outlatName: json["outlat_name"] == null ? "" : json["outlat_name"].toString(),
        districtId: json["district_id"] == null ? "" : json["district_id"].toString(),
        beatId: json["beat_id"] == null ? "" : json["beat_id"].toString(),
        beatName: json["beat_name"] == null ? "" : json["beat_name"].toString(),
        primaryAddress: json["primary_address"] == null ? "" : json["primary_address"].toString(),
        lat: json["lat"] == null ? "" : json["lat"].toString(),
        lng: json["lng"] == null ? "" : json["lng"].toString(),
        enrollmentTypeId: json["enrollment_type_id"] == null ? "" : json["enrollment_type_id"].toString(),
        primaryMobile: json["primary_mobile"] == null ? "" : json["primary_mobile"].toString(),
        secondaryMobile: json["secondary_mobile"] == null ? "Not given" : json["secondary_mobile"].toString(),
        orderBookingDay:
            json["order_booking_day"] == null ? DateFormat.EEEE().format(DateTime.now()) : json["order_booking_day"].toString(),
        connectionStatus: json["connection_status"] == null ? "" : json["connection_status"].toString(),
        remark: json["remark"] == null ? "" : json["remark"].toString(),
        potential: json["potential"] == null ? "" : json["potential"].toString(),
        outletPicture: json["outlet_picture"] == null ? "" : json["outlet_picture"].toString(),
        tcStatus: json["tc_status"] == null ? "Not Connected" : json["tc_status"].toString(),
        pendingTask: json["pending_task"] == null ? "0" : json["pending_task"].toString(),
        lastVisit: json["last_visit"] == null ? null : LastVisit.fromMap(json["last_visit"]),
        orderHistory:
            json["order_history"] == null ? [] : List<LastVisit>.from(json["order_history"].map((x) => LastVisit.fromMap(x))),
      );
}

class LastVisit {
  LastVisit({
    required this.id,
    required this.orderId,
    required this.orderDate,
    required this.orderStatus,
    required this.amount,
    required this.remark,
    required this.products,
  });

  String orderId;
  String id;
  String orderDate;
  String orderStatus;
  String amount;
  String remark;
  List<Product> products;

  factory LastVisit.fromJson(String str) => LastVisit.fromMap(json.decode(str));

  factory LastVisit.fromMap(Map<String, dynamic> json) => LastVisit(
        orderId: json["order_id"] == null ? "" : json["order_id"].toString(),
        id: json["id"] == null ? "" : json["id"].toString(),
        orderDate: json["order_date"] == null ? "" : json["order_date"].toString(),
        orderStatus: json["order_status"] == null ? "" : json["order_status"].toString(),
        amount: json["amount"] == null ? "" : json["amount"].toString(),
        remark: json["remark"] == null ? "" : json["remark"].toString(),
        products: json["products"] == null ? [] : List<Product>.from(json["products"].map((x) => Product.fromMap(x))),
      );
}

class Product {
  Product({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.categoryDescription,
    required this.variantId,
    required this.variantName,
    required this.variantDescription,
    required this.longDescription,
    required this.shortDescription,
    required this.mrp,
    required this.ptrPkgPrice,
    required this.ptrMoqPrice,
    required this.schemePkgPrice,
    required this.schemeMoqPrice,
    required this.totalAmount,
    required this.qtyPkg,
    required this.qtyMoq,
    required this.ptrRatePerPcs,
    required this.schemeRatePerPcs,
    required this.brandId,
    required this.brandName,
  });

  String id;
  String categoryId;
  String categoryName;
  String categoryDescription;
  String variantId;
  String variantName;
  String variantDescription;
  String longDescription;
  String shortDescription;
  String mrp;
  String ptrPkgPrice;
  String ptrMoqPrice;
  String schemePkgPrice;
  String schemeMoqPrice;
  String totalAmount;
  String qtyPkg;
  String qtyMoq;
  String ptrRatePerPcs;
  String schemeRatePerPcs;
  String brandId;
  String brandName;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"] == null ? "" : json["id"].toString(),
        categoryId: json["category_id"] == null ? "" : json["category_id"].toString(),
        categoryName: json["category_name"] == null ? "" : json["category_name"].toString(),
        categoryDescription: json["category_description"] == null ? "" : json["category_description"].toString(),
        variantId: json["variant_id"] == null ? "" : json["variant_id"].toString(),
        variantName: json["variant_name"] == null ? "" : json["variant_name"].toString(),
        variantDescription: json["variant_description"] == null ? "" : json["variant_description"].toString(),
        longDescription: json["long_description"] == null ? "" : json["long_description"].toString(),
        shortDescription: json["short_description"] == null ? "" : json["short_description"].toString(),
        mrp: json["mrp"] == null ? "0" : json["mrp"].toString(),
        ptrPkgPrice: json["ptr_pkg_price"] == null ? "0" : json["ptr_pkg_price"].toString(),
        ptrMoqPrice: json["ptr_moq_price"] == null ? "0" : json["ptr_moq_price"].toString(),
        schemePkgPrice: json["scheme_pkg_price"] == null ? "0" : json["scheme_pkg_price"].toString(),
        schemeMoqPrice: json["scheme_moq_price"] == null ? "0" : json["scheme_moq_price"].toString(),
        totalAmount: json["total_amount"] == null ? "0" : json["total_amount"].toString(),
        ptrRatePerPcs: json["ptr_rate_per_pcs"] == null ? "0" : json["ptr_rate_per_pcs"].toString(),
        schemeRatePerPcs: json["scheme_rate_per_pcs"] == null ? "0" : json["scheme_rate_per_pcs"].toString(),
        qtyPkg: json["qty_pkg"] == null ? "0" : json["qty_pkg"].toString(),
        qtyMoq: json["qty_moq"] == null ? "0" : json["qty_moq"].toString(),
        brandId: json["brand_id"] == null ? "0" : json["brand_id"].toString(),
        brandName: json["brand_name"] == null ? "" : json["brand_name"].toString(),
      );
}
