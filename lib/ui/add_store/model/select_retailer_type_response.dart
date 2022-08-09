import 'dart:convert';

class SelectRetailerTypeResponse {
  SelectRetailerTypeResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<RetailerTypeModel>? data;

  factory SelectRetailerTypeResponse.fromJson(String str) => SelectRetailerTypeResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectRetailerTypeResponse.fromMap(Map<String, dynamic> json) => SelectRetailerTypeResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "Something went wrong",
        data: json["data"] == null ? [] : List<RetailerTypeModel>.from(json["data"].map((x) => RetailerTypeModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class RetailerTypeModel {
  RetailerTypeModel({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory RetailerTypeModel.fromJson(String str) => RetailerTypeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RetailerTypeModel.fromMap(Map<String, dynamic> json) => RetailerTypeModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
