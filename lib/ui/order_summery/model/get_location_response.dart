// To parse this JSON data, do
//
//     final getLocationResponse = getLocationResponseFromMap(jsonString);

import 'dart:convert';

class GetLocationResponse {
  GetLocationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<LocationModel> data;

  factory GetLocationResponse.fromJson(String str) => GetLocationResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetLocationResponse.fromMap(Map<String, dynamic> json) => GetLocationResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "Location not fetch",
        data: json["data"] == null ? [] : List<LocationModel>.from(json["data"].map((x) => LocationModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class LocationModel {
  LocationModel({
    required this.id,
    required this.parentId,
    required this.locationCode,
    required this.locationDescription,
    required this.locationPincode,
    required this.isDelete,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String parentId;
  String locationCode;
  String locationDescription;
  String locationPincode;
  int isDelete;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;

  factory LocationModel.fromJson(String str) => LocationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LocationModel.fromMap(Map<String, dynamic> json) => LocationModel(
        id: json["id"] ?? 0,
        parentId: json["parent_id"] ?? "0",
        locationCode: json["location_code"] ?? "",
        locationDescription: json["location_description"] ?? "",
        locationPincode: json["location_pincode"] ?? "",
        isDelete: json["is_delete"] ?? 0,
        isActive: json["is_active"] ?? 0,
        createdAt: json["created_at"] == null ? DateTime.now() : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? DateTime.now() : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "parent_id": parentId,
        "location_code": locationCode,
        "location_description": locationDescription,
        "location_pincode": locationPincode,
        "is_delete": isDelete,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
