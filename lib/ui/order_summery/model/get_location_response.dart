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
    required this.name,
  });

  String id;
  String name;

  factory LocationModel.fromJson(String str) => LocationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LocationModel.fromMap(Map<String, dynamic> json) => LocationModel(
        id: json["id"] == null ? "0" : json["id"].toString(),
        name: json["name"] == null ? "0" : json["name"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
