// To parse this JSON data, do
//
//     final getAddPlanDataResponse = getAddPlanDataResponseFromMap(jsonString);

import 'dart:convert';

class GetAddPlanDataResponse {
  GetAddPlanDataResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum>? data;

  factory GetAddPlanDataResponse.fromJson(String str) =>
      GetAddPlanDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAddPlanDataResponse.fromMap(Map<String, dynamic> json) =>
      GetAddPlanDataResponse(
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
    required this.addPlanDate,
    required this.primaryTag,
    required this.secondaryTag,
    required this.remark,
  });

  int id;
  int userId;
  String addPlanDate;
  String primaryTag;
  String secondaryTag;
  String remark;

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        addPlanDate:
            json["add_plan_date"] == null ? null : json["add_plan_date"],
        primaryTag: json["primary_tag"] == null ? null : json["primary_tag"],
        secondaryTag:
            json["secondary_tag"] == null ? null : json["secondary_tag"],
        remark: json["remark"] == null ? null : json["remark"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "add_plan_date": addPlanDate == null ? null : addPlanDate,
        "primary_tag": primaryTag == null ? null : primaryTag,
        "secondary_tag": secondaryTag == null ? null : secondaryTag,
        "remark": remark == null ? null : remark,
      };
}
