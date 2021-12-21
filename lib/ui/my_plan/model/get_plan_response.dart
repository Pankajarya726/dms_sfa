// To parse this JSON data, do
//
//     final getPlanResponse = getPlanResponseFromMap(jsonString);

import 'dart:convert';

class GetPlanResponse {
  GetPlanResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<MyPlanModel> data;

  factory GetPlanResponse.fromJson(String str) => GetPlanResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetPlanResponse.fromMap(Map<String, dynamic> json) => GetPlanResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? [] : List<MyPlanModel>.from(json["data"].map((x) => MyPlanModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class MyPlanModel {
  MyPlanModel({
    required this.addPlanDate,
    required this.primaryTagId,
    required this.primaryTag,
    required this.secondaryTagId,
    required this.secondaryTag,
    required this.remark,
    required this.week,
  });

  DateTime addPlanDate;
  int primaryTagId;
  String primaryTag;
  int secondaryTagId;
  String secondaryTag;
  String remark;
  int week;

  factory MyPlanModel.fromJson(String str) => MyPlanModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyPlanModel.fromMap(Map<String, dynamic> json) => MyPlanModel(
        addPlanDate: json["add_plan_date"] == null ? DateTime.now() : DateTime.parse(json["add_plan_date"]),
        primaryTagId: json["primary_tag_id"] == null ? null : json["primary_tag_id"],
        primaryTag: json["primary_tag"] == null ? null : json["primary_tag"],
        secondaryTagId: json["secondary_tag_id"] == null ? null : json["secondary_tag_id"],
        secondaryTag: json["secondary_tag"] == null ? null : json["secondary_tag"],
        remark: json["remark"] == null ? null : json["remark"],
        week: json["week"] == null ? null : json["week"],
      );

  Map<String, dynamic> toMap() => {
        "add_plan_date": addPlanDate == null
            ? null
            : "${addPlanDate.year.toString().padLeft(4, '0')}-${addPlanDate.month.toString().padLeft(2, '0')}-${addPlanDate.day.toString().padLeft(2, '0')}",
        "primary_tag_id": primaryTagId == null ? null : primaryTagId,
        "primary_tag": primaryTag == null ? null : primaryTag,
        "secondary_tag_id": secondaryTagId == null ? null : secondaryTagId,
        "secondary_tag": secondaryTag == null ? null : secondaryTag,
        "remark": remark == null ? null : remark,
        "week": week == null ? null : week,
      };
}
