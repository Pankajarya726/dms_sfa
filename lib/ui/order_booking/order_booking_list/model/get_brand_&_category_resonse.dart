// To parse this JSON data, do
//
//     final getBrandCategoryResponse = getBrandCategoryResponseFromMap(jsonString);

import 'dart:convert';

class GetBrandCategoryResponse {
  GetBrandCategoryResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<BrandAndCategoryModel>? data;

  factory GetBrandCategoryResponse.fromJson(String str) =>
      GetBrandCategoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetBrandCategoryResponse.fromMap(Map<String, dynamic> json) =>
      GetBrandCategoryResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<BrandAndCategoryModel>.from(
                json["data"].map((x) => BrandAndCategoryModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class BrandAndCategoryModel {
  BrandAndCategoryModel({
    required this.id,
    required this.name,
    this.category,
  });

  String id;
  String name;
  List<Category>? category;

  factory BrandAndCategoryModel.fromJson(String str) =>
      BrandAndCategoryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BrandAndCategoryModel.fromMap(Map<String, dynamic> json) =>
      BrandAndCategoryModel(
        id: json["id"] == null ? "" : json["id"].toString(),
        name: json["name"] == null ? "" : json["name"].toString(),
        category: json["category"] == null
            ? []
            : List<Category>.from(
                json["category"].map((x) => Category.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "category": category == null
            ? []
            : List<dynamic>.from(category!.map((x) => x.toMap())),
      };
}

class Category {
  Category({
    required this.id,
    required this.categoryName,
  });

  String id;
  String categoryName;

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"] == null ? "" : json["id"].toString(),
        categoryName: json["category_name"] == null
            ? ""
            : json["category_name"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "category_name": categoryName,
      };
}
