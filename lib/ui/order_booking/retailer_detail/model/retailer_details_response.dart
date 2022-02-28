import 'dart:convert';

class RetailersDetailsResponse {
  RetailersDetailsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<RetailerDetailsModal>? data;

  factory RetailersDetailsResponse.fromJson(String str) =>
      RetailersDetailsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RetailersDetailsResponse.fromMap(Map<String, dynamic> json) =>
      RetailersDetailsResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<RetailerDetailsModal>.from(
                json["data"].map((x) => RetailerDetailsModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
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
    required this.connectionStatus,
    required this.remark,
    required this.potential,
    required this.outletPicture,
    required this.tcStatus,
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
  String connectionStatus;
  String remark;
  String potential;
  String outletPicture;
  String tcStatus;
  LastVisit? lastVisit;
  List<LastVisit>? orderHistory;

  factory RetailerDetailsModal.fromJson(String str) =>
      RetailerDetailsModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RetailerDetailsModal.fromMap(Map<String, dynamic> json) =>
      RetailerDetailsModal(
        customerId:
            json["customer_id"] == null ? "" : json["customer_id"].toString(),
        userId: json["user_id"] == null ? "" : json["user_id"].toString(),
        uniqueCode:
            json["unique_code"] == null ? "" : json["unique_code"].toString(),
        customerName: json["customer_name"] == null
            ? ""
            : json["customer_name"].toString(),
        outlatName:
            json["outlat_name"] == null ? "" : json["outlat_name"].toString(),
        districtId:
            json["district_id"] == null ? "" : json["district_id"].toString(),
        beatId: json["beat_id"] == null ? "" : json["beat_id"].toString(),
        beatName: json["beat_name"] == null ? "" : json["beat_name"].toString(),
        primaryAddress: json["primary_address"] == null
            ? ""
            : json["primary_address"].toString(),
        lat: json["lat"] == null ? "" : json["lat"].toString(),
        lng: json["lng"] == null ? "" : json["lng"].toString(),
        enrollmentTypeId: json["enrollment_type_id"] == null
            ? ""
            : json["enrollment_type_id"].toString(),
        primaryMobile: json["primary_mobile"] == null
            ? ""
            : json["primary_mobile"].toString(),
        secondaryMobile: json["secondary_mobile"] == null
            ? ""
            : json["secondary_mobile"].toString(),
        connectionStatus: json["connection_status"] == null
            ? ""
            : json["connection_status"].toString(),
        remark: json["remark"] == null ? "" : json["remark"].toString(),
        potential:
            json["potential"] == null ? "" : json["potential"].toString(),
        outletPicture: json["outlet_picture"] == null
            ? ""
            : json["outlet_picture"].toString(),
        tcStatus: json["tc_status"] == null ? "" : json["tc_status"].toString(),
        lastVisit: json["last_visit"] == null
            ? null
            : LastVisit.fromMap(json["last_visit"]),
        orderHistory: json["order_history"] == null
            ? []
            : List<LastVisit>.from(
                json["order_history"].map((x) => LastVisit.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "customer_id": customerId,
        "user_id": userId,
        "unique_code": uniqueCode,
        "customer_name": customerName,
        "outlat_name": outlatName,
        "district_id": districtId,
        "beat_id": beatId,
        "beat_name": beatName,
        "primary_address": primaryAddress,
        "lat": lat,
        "lng": lng,
        "enrollment_type_id": enrollmentTypeId,
        "primary_mobile": primaryMobile,
        "secondary_mobile": secondaryMobile,
        "connection_status": connectionStatus,
        "remark": remark,
        "potential": potential,
        "outlet_picture": outletPicture,
        "tc_status": tcStatus,
        "last_visit": lastVisit == null ? null : lastVisit!.toMap(),
        "order_history": orderHistory == null
            ? []
            : List<dynamic>.from(orderHistory!.map((x) => x.toMap())),
      };
}

class LastVisit {
  LastVisit({
    required this.orderId,
    required this.orderDate,
    required this.amount,
    required this.remark,
    required this.products,
  });

  String orderId;
  String orderDate;
  String amount;
  String remark;
  List<Product>? products;

  factory LastVisit.fromJson(String str) => LastVisit.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LastVisit.fromMap(Map<String, dynamic> json) => LastVisit(
        orderId: json["order_id"] == null ? "" : json["order_id"].toString(),
        orderDate:
            json["order_date"] == null ? "" : json["order_date"].toString(),
        amount: json["amount"] == null ? "" : json["amount"].toString(),
        remark: json["remark"] == null ? "" : json["remark"].toString(),
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"].map((x) => Product.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId,
        "order_date": orderDate,
        "amount": amount,
        "remark": remark,
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toMap())),
      };
}

class Product {
  Product({
    required this.id,
    required this.category,
    required this.mrp,
    required this.ptr,
    required this.moq,
    required this.qtyPkg,
    required this.qtyMoq,
  });

  String id;
  String category;
  String mrp;
  String ptr;
  String moq;
  String qtyPkg;
  String qtyMoq;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"] == null ? "" : json["id"].toString(),
        category: json["category"] == null ? "" : json["category"].toString(),
        mrp: json["mrp"] == null ? "" : json["mrp"].toString(),
        ptr: json["ptr"] == null ? "" : json["ptr"].toString(),
        moq: json["moq"] == null ? "" : json["moq"].toString(),
        qtyPkg: json["qty_pkg"] == null ? "" : json["qty_pkg"].toString(),
        qtyMoq: json["qty_moq"] == null ? "" : json["qty_moq"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "category": category,
        "mrp": mrp,
        "ptr": ptr,
        "moq": moq,
        "qty_pkg": qtyPkg,
        "qty_moq": qtyMoq,
      };
}
