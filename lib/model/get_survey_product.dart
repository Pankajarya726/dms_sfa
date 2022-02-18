// To parse this JSON data, do
//
//     final getSurveyProduct = getSurveyProductFromMap(jsonString);

import 'dart:convert';

class GetSurveyProduct {
  GetSurveyProduct({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<SurveyProduct> data;

  factory GetSurveyProduct.fromJson(String str) => GetSurveyProduct.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetSurveyProduct.fromMap(Map<String, dynamic> json) => GetSurveyProduct(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<SurveyProduct>.from(json["data"].map((x) => SurveyProduct.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class SurveyProduct {
  SurveyProduct({
    required this.id,
    required this.categoryName,
    required this.categoryImage,
    required this.categoryDescription,
    required this.brand,
  });

  int id;
  String categoryName;
  String categoryImage;
  String categoryDescription;
  bool check = false;
  List<Brand> brand;

  factory SurveyProduct.fromJson(String str) => SurveyProduct.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SurveyProduct.fromMap(Map<String, dynamic> json) => SurveyProduct(
        id: json["id"] ?? 0,
        categoryName: json["category_name"] ?? "",
        categoryImage: json["category_image"] ?? "",
        categoryDescription: json["category_description"] ?? "",
        brand: json["brand"] == null ? [] : List<Brand>.from(json["brand"].map((x) => Brand.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "category_name": categoryName,
        "category_image": categoryName,
        "category_description": categoryDescription,
        "brand": brand == null ? [] : List<dynamic>.from(brand.map((x) => x.toMap())),
      };

  @override
  String toString() {
    return 'SurveyProduct{id: $id, categoryName: $categoryName, categoryDescription: $categoryDescription, check: $check, brand: $brand}';
  }
}

class Brand {
  Brand({
    required this.id,
    required this.brandName,
  });

  int id;
  String brandName;
  bool check = false;

  factory Brand.fromJson(String str) => Brand.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Brand.fromMap(Map<String, dynamic> json) => Brand(
        id: json["id"],
        brandName: json["brand_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "brand_name": brandName,
      };

  @override
  String toString() {
    return 'Brand{id: $id, brandName: $brandName, check: $check}';
  }
}
