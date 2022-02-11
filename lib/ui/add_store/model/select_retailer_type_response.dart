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

  factory SelectRetailerTypeResponse.fromJson(String str) =>
      SelectRetailerTypeResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectRetailerTypeResponse.fromMap(Map<String, dynamic> json) =>
      SelectRetailerTypeResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<RetailerTypeModel>.from(
                json["data"].map((x) => RetailerTypeModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class RetailerTypeModel {
  RetailerTypeModel({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory RetailerTypeModel.fromJson(String str) =>
      RetailerTypeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RetailerTypeModel.fromMap(Map<String, dynamic> json) =>
      RetailerTypeModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
