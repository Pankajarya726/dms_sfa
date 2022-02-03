// To parse this JSON data, do
//
//     final editStoreGetEnrollTypeResponse = editStoreGetEnrollTypeResponseFromMap(jsonString);

import 'dart:convert';

class EditStoreGetEnrollTypeResponse {
  EditStoreGetEnrollTypeResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum>? data;

  factory EditStoreGetEnrollTypeResponse.fromJson(String str) =>
      EditStoreGetEnrollTypeResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EditStoreGetEnrollTypeResponse.fromMap(Map<String, dynamic> json) =>
      EditStoreGetEnrollTypeResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.enrollmentType,
  });

  int id;
  String enrollmentType;

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        enrollmentType:
            json["enrollment_type"] == null ? null : json["enrollment_type"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "enrollment_type": enrollmentType == null ? null : enrollmentType,
      };
}
