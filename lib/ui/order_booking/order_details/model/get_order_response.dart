import 'dart:convert';

class GetOrderResponse {
  GetOrderResponse({
    required this.success,
    required this.message,
    required this.task,
    required this.orders,
    required this.data,
  });

  bool success;
  String message;
  List<Task> task;
  List<Order> orders;
  List<Product> data;

  factory GetOrderResponse.fromJson(String str) => GetOrderResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetOrderResponse.fromMap(Map<String, dynamic> json) => GetOrderResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        task: json["task"] == null ? [] : List<Task>.from(json["task"].map((x) => Task.fromMap(x))),
        orders: json["orders"] == null ? [] : List<Order>.from(json["orders"].map((x) => Order.fromMap(x))),
        data: json["data"] == null ? [] : List<Product>.from(json["data"].map((x) => Product.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "task": List<dynamic>.from(task.map((x) => x.toMap())),
        "orders": List<dynamic>.from(orders.map((x) => x.toMap())),
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Product {
  Product({
    required this.id,
    required this.productName,
    required this.mrp,
    required this.schemeRatePerPcs,
    required this.image,
    required this.skuRatePerPkg,
    required this.skuRatePerMoq,
    required this.skuRatePerPiece,
    required this.moqId,
    required this.moqName,
    required this.packagingId,
    required this.packagingName,
    required this.skuCode,
    required this.weight,
    required this.variantId,
    required this.variantName,
    required this.brandId,
    required this.brandName,
    required this.categoryId,
    required this.categoryName,
    required this.longDescription,
    required this.pcsPerMoq,
    required this.pcsPerPackaging,
    required this.saleableStockPcs,
    required this.priceAfterDiscount,
    required this.customerId,
    required this.buId,
    required this.rateCategoryId,
    required this.orderId,
    required this.orderSkuId,
    required this.orderQtyMoq,
    required this.orderQtyPkg,
    required this.orderSkuAmount,
    required this.schemes,
  });

  String id;
  String productName;
  String mrp;
  String schemeRatePerPcs;
  String image;
  String skuRatePerPkg;
  String skuRatePerMoq;
  String skuRatePerPiece;
  String moqId;
  String moqName;
  String packagingId;
  String packagingName;
  String skuCode;
  String weight;
  String variantId;
  String variantName;
  String brandId;
  String brandName;
  String categoryId;
  String categoryName;
  String longDescription;
  int pcsPerMoq;
  int pcsPerPackaging;
  int saleableStockPcs;
  String priceAfterDiscount;
  String customerId;
  String buId;
  String rateCategoryId;
  String orderId;
  String orderSkuId;
  int orderQtyMoq;
  int orderQtyPkg;
  String orderSkuAmount;
  List<Scheme> schemes;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"] == null ? '0' : json["id"].toString(),
        productName: json["product_name"] == null ? "" : json["product_name"].toString(),
        mrp: json["mrp"] == null ? "0" : json["mrp"].toString(),
        schemeRatePerPcs: json["scheme_rate_per_pcs"] == null ? "0" : json["scheme_rate_per_pcs"].toString(),
        image: json["image"] ?? "",
        skuRatePerPkg: json["sku_rate_per_pkg"] == null ? "0" : json["sku_rate_per_pkg"].toString(),
        skuRatePerMoq: json["sku_rate_per_moq"] == null ? "0" : json["sku_rate_per_moq"].toString(),
        skuRatePerPiece: json["sku_rate_per_piece"] == null ? "0" : json["sku_rate_per_piece"].toString(),
        moqId: json["moq_id"] == null ? "0" : json["moq_id"].toString(),
        moqName: json["moq_name"] == null ? "" : json["moq_name"].toString(),
        packagingId: json["packaging_id"] == null ? "0" : json["packaging_id"].toString(),
        packagingName: json["packaging_name"] == null ? "" : json["packaging_name"].toString(),
        skuCode: json["sku_code"] == null ? "" : json["sku_code"].toString(),
        weight: json["weight"] == null ? "" : json["weight"].toString(),
        variantId: json["variant_id"] == null ? "0" : json["variant_id"].toString(),
        variantName: json["variant_name"] == null ? "" : json["variant_name"].toString(),
        brandId: json["brand_id"] == null ? "0" : json["brand_id"].toString(),
        brandName: json["brand_name"] == null ? "" : json["brand_name"].toString(),
        categoryId: json["category_id"] == null ? "0" : json["category_id"].toString(),
        categoryName: json["category_name"] == null ? "" : json["category_name"].toString(),
        longDescription: json["long_description"] == null ? "" : json["long_description"].toString(),
        pcsPerMoq: json["pcs_per_moq"] ?? 0,
        pcsPerPackaging: json["pcs_per_packaging"] ?? 0,
        saleableStockPcs: json["saleable_stock_pcs"] ?? 0,
        priceAfterDiscount: json["price_after_discount"] == null ? "0" : json["price_after_discount"].toString(),
        customerId: json["customer_id"] == null ? "0" : json["customer_id"].toString(),
        buId: json["bu_id"] == null ? "0" : json["bu_id"].toString(),
        rateCategoryId: json["rate_category_id"] == null ? "0" : json["rate_category_id"].toString(),
        orderId: json["order_id"] == null ? "0" : json["order_id"].toString(),
        orderSkuId: json["order_sku_id"] == null ? "0" : json["order_sku_id"].toString(),
        orderQtyMoq: json["order_qty_moq"] ?? 0,
        orderQtyPkg: json["order_qty_pkg"] ?? 0,
        orderSkuAmount: json["order_sku_amount"] == null ? "0" : json["order_sku_amount"].toString(),
        schemes: json["schemes"] == null ? [] : List<Scheme>.from(json["schemes"].map((x) => Scheme.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "product_name": productName,
        "mrp": mrp,
        "scheme_rate_per_pcs": schemeRatePerPcs,
        "image": image,
        "sku_rate_per_pkg": skuRatePerPkg,
        "sku_rate_per_moq": skuRatePerMoq,
        "sku_rate_per_piece": skuRatePerPiece,
        "moq_id": moqId,
        "moq_name": moqName,
        "packaging_id": packagingId,
        "packaging_name": packagingName,
        "sku_code": skuCode,
        "weight": weight,
        "variant_id": variantId,
        "variant_name": variantName,
        "brand_id": brandId,
        "brand_name": brandName,
        "category_id": categoryId,
        "category_name": categoryName,
        "long_description": longDescription,
        "pcs_per_moq": pcsPerMoq,
        "pcs_per_packaging": pcsPerPackaging,
        "saleable_stock_pcs": saleableStockPcs,
        "price_after_discount": priceAfterDiscount,
        "customer_id": customerId,
        "bu_id": buId,
        "rate_category_id": rateCategoryId,
        "order_id": orderId,
        "order_sku_id": orderSkuId,
        "order_qty_moq": orderQtyMoq,
        "order_qty_pkg": orderQtyPkg,
        "order_sku_amount": orderSkuAmount,
        "schemes": List<dynamic>.from(schemes.map((x) => x.toMap())),
      };
}

class Scheme {
  Scheme({
    required this.id,
    required this.schemeName,
    required this.schemeType,
    required this.skuMasterId,
    required this.skubuCode,
    required this.productCategory,
    required this.customerId,
    required this.customerCode,
    required this.zoneId,
    required this.stateId,
    required this.districtId,
    required this.cityId,
    required this.discountPercentage,
    required this.discountAmount,
    required this.uom,
    required this.fromDate,
    required this.toDate,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String schemeName;
  String schemeType;
  String skuMasterId;
  String skubuCode;
  String productCategory;
  String customerId;
  String customerCode;
  String zoneId;
  String stateId;
  String districtId;
  String cityId;
  String discountPercentage;
  String discountAmount;
  String uom;
  DateTime fromDate;
  DateTime toDate;
  String isActive;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory Scheme.fromJson(String str) => Scheme.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Scheme.fromMap(Map<String, dynamic> json) => Scheme(
        id: json["id"] == null ? "" : json["id"].toString(),
        schemeName: json["scheme_name"] == null ? "" : json["scheme_name"].toString(),
        schemeType: json["scheme_type"] == null ? "" : json["scheme_type"].toString(),
        skuMasterId: json["sku_master_id"] == null ? "" : json["sku_master_id"].toString(),
        skubuCode: json["skubu_code"] == null ? "" : json["skubu_code"].toString(),
        productCategory: json["product_category"] == null ? "" : json["product_category"].toString(),
        customerId: json["customer_id"] == null ? "" : json["customer_id"].toString(),
        customerCode: json["customer_code"] == null ? "" : json["customer_code"].toString(),
        zoneId: json["zone_id"] == null ? "" : json["zone_id"].toString(),
        stateId: json["state_id"] == null ? "" : json["state_id"].toString(),
        districtId: json["district_id"] == null ? "" : json["district_id"].toString(),
        cityId: json["city_id"] == null ? "" : json["city_id"].toString(),
        discountPercentage: json["discount_percentage"].toString(),
        discountAmount: json["discount_amount"] == null ? "" : json["discount_amount"].toString(),
        uom: json["uom"] == null ? "" : json["uom"].toString(),
        fromDate: json["from_date"] == null ? DateTime.now() : DateTime.parse(json["from_date"]),
        toDate: json["to_date"] == null ? DateTime.now() : DateTime.parse(json["to_date"]),
        isActive: json["is_active"] == null ? "" : json["is_active"].toString(),
        createdBy: json["created_by"] == null ? "" : json["created_by"].toString(),
        createdAt: json["created_at"] == null ? DateTime.now() : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? DateTime.now() : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "scheme_name": schemeName,
        "scheme_type": schemeType,
        "sku_master_id": skuMasterId,
        "skubu_code": skubuCode,
        "product_category": productCategory,
        "customer_id": customerId,
        "customer_code": customerCode,
        "zone_id": zoneId,
        "state_id": stateId,
        "district_id": districtId,
        "city_id": cityId,
        "discount_percentage": discountPercentage,
        "discount_amount": discountAmount,
        "uom": uom,
        "from_date": fromDate == null
            ? null
            : "${fromDate.year.toString().padLeft(4, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
        "to_date": toDate == null
            ? null
            : "${toDate.year.toString().padLeft(4, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}",
        "is_active": isActive,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Order {
  Order({
    required this.orderId,
    required this.retailerId,
    required this.totalPkg,
    required this.totalMoq,
    required this.totalAmount,
  });

  int orderId;
  int retailerId;
  int totalPkg;
  int totalMoq;
  String totalAmount;

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Order.fromMap(Map<String, dynamic> json) => Order(
        orderId: json["order_id"] ?? 0,
        retailerId: json["retailer_id"] ?? 0,
        totalPkg: json["total_pkg"] ?? 0,
        totalMoq: json["total_moq"] ?? 0,
        totalAmount: json["total_amount"] == null ? "0" : json["total_amount"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId,
        "retailer_id": retailerId,
        "total_pkg": totalPkg,
        "total_moq": totalMoq,
        "total_amount": totalAmount,
      };
}

class Task {
  Task({
    required this.id,
    required this.taskId,
    required this.escalationTag,
    required this.buId,
  });

  String id;
  String taskId;
  String escalationTag;
  List<BuId> buId;

  factory Task.fromJson(String str) => Task.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json["id"] == null ? "0" : json["id"].toString(),
        taskId: json["task_id"] == null ? "0" : json["task_id"].toString(),
        escalationTag: json["escalation_tag"] == null ? "" : json["escalation_tag"].toString(),
        buId: json["bu_id"] == null ? [] : List<BuId>.from(json["bu_id"].map((x) => BuId.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "task_id": taskId,
        "escalation_tag": escalationTag,
        "bu_id": buId == null ? null : List<dynamic>.from(buId.map((x) => x.toMap())),
      };
}

class BuId {
  BuId({
    required this.id,
    required this.buName,
  });

  int id;
  String buName;

  factory BuId.fromJson(String str) => BuId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BuId.fromMap(Map<String, dynamic> json) => BuId(
        id: json["id"] == null ? null : json["id"],
        buName: json["bu_name"] == null ? null : json["bu_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "bu_name": buName == null ? null : buName,
      };
}
