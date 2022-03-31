import 'dart:convert';

class GetProductsResponse {
  GetProductsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<ProductsModal>? data;

  factory GetProductsResponse.fromJson(String str) => GetProductsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetProductsResponse.fromMap(Map<String, dynamic> json) => GetProductsResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? [] : List<ProductsModal>.from(json["data"].map((x) => ProductsModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class ProductsModal {
  ProductsModal({
    required this.id,
    required this.productName,
    required this.mrp,
    required this.ptr,
    required this.image,
    required this.skuRatePerPkg,
    required this.skuRatePerMoq,
    required this.skuRatePerPiece,
    required this.moqName,
    required this.moqId,
    required this.packagingName,
    required this.packagingId,
    required this.skuCode,
    required this.weight,
    required this.variantName,
    required this.variant_id,
    required this.brand_id,
    required this.brand_name,
    required this.bu_id,
    required this.longDescription,
    required this.pcsPerMoq,
    required this.pcsPerPackaging,
    required this.priceAfterDiscount,
    required this.customerId,
    required this.saleableStockPcs,
    required this.schemes,
  });

  String id;
  String productName;
  String mrp;
  String ptr;
  String image;
  String skuRatePerPkg;
  String skuRatePerMoq;
  String skuRatePerPiece;
  String moqName;
  String moqId;
  String packagingName;
  String packagingId;
  String skuCode;
  String weight;
  String variantName;
  String variant_id;
  String brand_id;
  String brand_name;
  String bu_id;
  String longDescription;
  String pcsPerMoq;
  String pcsPerPackaging;
  String priceAfterDiscount;
  String customerId;
  String saleableStockPcs;
  List<Scheme>? schemes;
  int pkgQty = 0;
  int moqQty = 0;

  factory ProductsModal.fromJson(String str) => ProductsModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductsModal.fromMap(Map<String, dynamic> json) => ProductsModal(
        id: json["id"] == null ? "" : json["id"].toString(),
        productName: json["product_name"] == null ? "" : json["product_name"].toString(),
        mrp: json["mrp"] == null ? "" : json["mrp"].toString(),
        ptr: json["ptr"] == null ? "" : json["ptr"].toString(),
        image: json["image"] == null ? "" : json["image"].toString(),
        skuRatePerPkg: json["sku_rate_per_pkg"] == null ? "" : json["sku_rate_per_pkg"].toString(),
        skuRatePerMoq: json["sku_rate_per_moq"] == null ? "" : json["sku_rate_per_moq"].toString(),
        skuRatePerPiece: json["sku_rate_per_piece"] == null ? "" : json["sku_rate_per_piece"].toString(),
        moqName: json["moq_name"] == null ? "" : json["moq_name"].toString(),
        moqId: json["moq_id"] == null ? "" : json["moq_id"].toString(),
        packagingName: json["packaging_name"] == null ? "" : json["packaging_name"].toString(),
        packagingId: json["packaging_id"] == null ? "" : json["packaging_id"].toString(),
        skuCode: json["sku_code"] == null ? "" : json["sku_code"].toString(),
        weight: json["weight"] == null ? "" : json["weight"].toString(),
        variantName: json["variant_name"] == null ? "" : json["variant_name"].toString(),
        variant_id: json["variant_id"] == null ? "" : json["variant_id"].toString(),
        brand_id: json["brand_id"] == null ? "" : json["brand_id"].toString(),
        brand_name: json["brand_name"] == null ? "" : json["brand_name"].toString(),
        bu_id: json["bu_id"] == null ? "" : json["bu_id"].toString(),
        longDescription: json["long_description"] == null ? "" : json["long_description"].toString(),
        pcsPerMoq: json["pcs_per_moq"] == null ? "" : json["pcs_per_moq"].toString(),
        pcsPerPackaging: json["pcs_per_packaging"] == null ? "" : json["pcs_per_packaging"].toString(),
        priceAfterDiscount: json["price_after_discount"] == null ? "" : json["price_after_discount"].toString(),
        customerId: json["customer_id"] == null ? "" : json["customer_id"].toString(),
        saleableStockPcs: json["saleable_stock_pcs"] == null ? "" : json["saleable_stock_pcs"].toString(),
        schemes: json["schemes"] == null ? [] : List<Scheme>.from(json["schemes"].map((x) => Scheme.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "product_name": productName,
        "mrp": mrp,
        "ptr": ptr,
        "image": image,
        "sku_rate_per_pkg": skuRatePerPkg,
        "sku_rate_per_moq": skuRatePerMoq,
        "sku_rate_per_piece": skuRatePerPiece,
        "moq_name": moqName,
        "moq_id": moqId,
        "packaging_name": packagingName,
        "packaging_id": packagingId,
        "sku_code": skuCode,
        "weight": weight,
        "variant_name": variantName,
        "variant_id": variant_id,
        "brand_id": brand_id,
        "brand_name": brand_name,
        "bu_id": bu_id,
        "long_description": longDescription,
        "pcs_per_moq": pcsPerMoq,
        "pcs_per_packaging": pcsPerPackaging,
        "price_after_discount": priceAfterDiscount,
        "customer_id": customerId,
        "saleable_stock_pcs": saleableStockPcs,
        "schemes": schemes == null ? [] : List<dynamic>.from(schemes!.map((x) => x.toMap())),
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
  String fromDate;
  String toDate;
  String isActive;
  String createdBy;
  String createdAt;
  String updatedAt;

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
        discountPercentage: json["discount_percentage"] == null ? "" : json["discount_percentage"].toString(),
        discountAmount: json["discount_amount"] == null ? "" : json["discount_amount"].toString(),
        uom: json["uom"] == null ? "" : json["uom"].toString(),
        fromDate: json["from_date"] == null ? "" : json["from_date"].toString(),
        toDate: json["to_date"] == null ? "" : json["to_date"].toString(),
        isActive: json["is_active"] == null ? "" : json["is_active"].toString(),
        createdBy: json["created_by"] == null ? "" : json["created_by"].toString(),
        createdAt: json["created_at"] == null ? "" : json["created_at"].toString(),
        updatedAt: json["updated_at"] == null ? "" : json["updated_at"].toString(),
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
        "from_date": fromDate,
        "to_date": toDate,
        "is_active": isActive,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
