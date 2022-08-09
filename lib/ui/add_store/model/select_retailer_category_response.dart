// To parse this JSON data, do
//
//     final selectRetailerCategoryResponse = selectRetailerCategoryResponseFromMap(jsonString);

import 'dart:convert';

class SelectRetailerCategoryResponse {
  SelectRetailerCategoryResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<RetailerCategoryModel>? data;

  factory SelectRetailerCategoryResponse.fromJson(String str) => SelectRetailerCategoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectRetailerCategoryResponse.fromMap(Map<String, dynamic> json) => SelectRetailerCategoryResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "Something went wrong",
        data: json["data"] == null ? [] : List<RetailerCategoryModel>.from(json["data"].map((x) => RetailerCategoryModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class RetailerCategoryModel {
  RetailerCategoryModel({
    required this.id,
    required this.category,
  });

  int id;
  String category;

  factory RetailerCategoryModel.fromJson(String str) => RetailerCategoryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RetailerCategoryModel.fromMap(Map<String, dynamic> json) => RetailerCategoryModel(
        id: json["id"] ?? 0,
        category: json["category"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "category": category,
      };
}
