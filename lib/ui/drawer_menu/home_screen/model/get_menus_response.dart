// To parse this JSON data, do
//
//     final GetMenusResponse = GetMenusResponseFromMap(jsonString);

import 'dart:convert';

class GetMenusResponse {
  GetMenusResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<MenuData>? data;

  factory GetMenusResponse.fromJson(String str) => GetMenusResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetMenusResponse.fromMap(Map<String, dynamic> json) => GetMenusResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : List<MenuData>.from(json["data"].map((x) => MenuData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class MenuData {
  MenuData({
    required this.id,
    required this.menuName,
    required this.menuDescription,
    required this.menuImage,
    required this.isActive,
    required this.sort,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String menuName;
  String menuDescription;
  String menuImage;
  int isActive;
  int sort;
  String createdAt;
  String updatedAt;

  factory MenuData.fromJson(String str) => MenuData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MenuData.fromMap(Map<String, dynamic> json) => MenuData(
        id: json["id"],
        menuName: json["menu_name"],
        menuDescription: json["menu_description"],
        menuImage: json["menu_image"],
        isActive: json["is_active"],
        sort: json["sort"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "menu_name": menuName,
        "menu_description": menuDescription,
        "menu_image": menuImage,
        "is_active": isActive,
        "sort": sort,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
