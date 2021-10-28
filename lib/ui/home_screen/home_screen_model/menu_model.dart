// To parse this JSON data, do
//
//     final homeMenuResponse = homeMenuResponseFromMap(jsonString);

import 'dart:convert';

class HomeMenuResponse {
  HomeMenuResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<HomeMenu>? data;

  factory HomeMenuResponse.fromJson(String str) =>
      HomeMenuResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HomeMenuResponse.fromMap(Map<String, dynamic> json) =>
      HomeMenuResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<HomeMenu>.from(json["data"].map((x) => HomeMenu.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class HomeMenu {
  HomeMenu({
    required this.id,
    required this.menuName,
    required this.menuDescription,
    required this.menuImage,
    required this.isActive,
    required this.sort,
  });

  int id;
  String menuName;
  String menuDescription;
  String menuImage;
  int isActive;
  int sort;

  factory HomeMenu.fromJson(String str) => HomeMenu.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HomeMenu.fromMap(Map<String, dynamic> json) => HomeMenu(
        id: json["id"] == null ? null : json["id"],
        menuName: json["menu_name"] == null ? null : json["menu_name"],
        menuDescription:
            json["menu_description"] == null ? null : json["menu_description"],
        menuImage: json["menu_image"] == null ? null : json["menu_image"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        sort: json["sort"] == null ? null : json["sort"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "menu_name": menuName == null ? null : menuName,
        "menu_description": menuDescription == null ? null : menuDescription,
        "menu_image": menuImage == null ? null : menuImage,
        "is_active": isActive == null ? null : isActive,
        "sort": sort == null ? null : sort,
      };
}
