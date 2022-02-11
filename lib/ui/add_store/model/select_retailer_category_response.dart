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

  factory SelectRetailerCategoryResponse.fromJson(String str) =>
      SelectRetailerCategoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectRetailerCategoryResponse.fromMap(Map<String, dynamic> json) =>
      SelectRetailerCategoryResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<RetailerCategoryModel>.from(
                json["data"].map((x) => RetailerCategoryModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class RetailerCategoryModel {
  RetailerCategoryModel({
    required this.id,
    required this.category,
  });

  int id;
  String category;

  factory RetailerCategoryModel.fromJson(String str) =>
      RetailerCategoryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RetailerCategoryModel.fromMap(Map<String, dynamic> json) =>
      RetailerCategoryModel(
        id: json["id"] == null ? null : json["id"],
        category: json["category"] == null ? null : json["category"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "category": category == null ? null : category,
      };
}
