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
  List<Datum>? data;

  factory GetMenusResponse.fromJson(String str) =>
      GetMenusResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetMenusResponse.fromMap(Map<String, dynamic> json) =>
      GetMenusResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Datum {
  Datum({
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

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        menuName: json["menu_name"] == null ? null : json["menu_name"],
        menuDescription:
            json["menu_description"] == null ? null : json["menu_description"],
        menuImage: json["menu_image"] == null ? null : json["menu_image"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        sort: json["sort"] == null ? null : json["sort"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "menu_name": menuName == null ? null : menuName,
        "menu_description": menuDescription == null ? null : menuDescription,
        "menu_image": menuImage == null ? null : menuImage,
        "is_active": isActive == null ? null : isActive,
        "sort": sort == null ? null : sort,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
      };
}
