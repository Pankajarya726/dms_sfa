// To parse this JSON data, do
//
//     final GetEnrollTypeResponse = GetEnrollTypeResponseFromMap(jsonString);

import 'dart:convert';

class GetEnrollTypeResponse {
  GetEnrollTypeResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<EnrolmentTypeModel>? data;

  factory GetEnrollTypeResponse.fromJson(String str) => GetEnrollTypeResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetEnrollTypeResponse.fromMap(Map<String, dynamic> json) => GetEnrollTypeResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "Something went wrong",
        data: json["data"] == null ? [] : List<EnrolmentTypeModel>.from(json["data"].map((x) => EnrolmentTypeModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class EnrolmentTypeModel {
  EnrolmentTypeModel({
    required this.id,
    required this.enrollmentType,
  });

  int id;
  String enrollmentType;

  factory EnrolmentTypeModel.fromJson(String str) => EnrolmentTypeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EnrolmentTypeModel.fromMap(Map<String, dynamic> json) => EnrolmentTypeModel(
        id: json["id"] ?? 0,
        enrollmentType: json["type"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": enrollmentType,
      };
}
