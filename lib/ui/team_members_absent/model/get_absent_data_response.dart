// To parse this JSON data, do
//
//     final getAbsentDataResponse = getAbsentDataResponseFromMap(jsonString);

import 'dart:convert';

class GetAbsentDataResponse {
  GetAbsentDataResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum>? data;

  factory GetAbsentDataResponse.fromJson(String str) =>
      GetAbsentDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAbsentDataResponse.fromMap(Map<String, dynamic> json) =>
      GetAbsentDataResponse(
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
    required this.userId,
    required this.createdAt,
    required this.inOutStatus,
    required this.name,
    required this.absentReason,
  });

  int id;
  int userId;
  DateTime createdAt;
  int inOutStatus;
  String name;
  String absentReason;

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]),
        inOutStatus:
            json["in_out_status"] == null ? null : json["in_out_status"],
        name: json["name"] == null ? null : json["name"],
        absentReason:
            json["absent_reason"] == null ? null : json["absent_reason"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "in_out_status": inOutStatus == null ? null : inOutStatus,
        "name": name == null ? null : name,
        "absent_reason": absentReason == null ? null : absentReason,
      };
}
