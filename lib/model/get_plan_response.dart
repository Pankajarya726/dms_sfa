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
  List<PlanDataModel> data;

  factory GetPlanResponse.fromJson(String str) => GetPlanResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetPlanResponse.fromMap(Map<String, dynamic> json) => GetPlanResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? [] : List<PlanDataModel>.from(json["data"].map((x) => PlanDataModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success ?? false,
        "message": message ?? "",
        "data": data == null ? [] : List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class PlanDataModel {
  PlanDataModel({
    required this.id,
    required this.userId,
    required this.addPlanDate,
    required this.primaryTagId,
    required this.primaryTag,
    required this.secondaryTagId,
    required this.secondaryTag,
    required this.remark,
    required this.week,
  });

  String id;
  String userId;
  DateTime addPlanDate;
  String primaryTagId;
  String primaryTag;
  String secondaryTagId;
  String secondaryTag;
  String remark;
  String week;

  factory PlanDataModel.fromJson(String str) => PlanDataModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlanDataModel.fromMap(Map<String, dynamic> json) => PlanDataModel(
        id: json["id"] == null ? "0" : json["id"].toString(),
        userId: json["user_id"] == null ? "0" : json["user_id"].toString(),
        addPlanDate: json["add_plan_date"] == DateTime.now() ? DateTime.now() : DateTime.parse(json["add_plan_date"]),
        primaryTagId: json["primary_tag_id"] == null ? "0" : json["primary_tag_id"].toString(),
        primaryTag: json["primary_tag"] ?? "",
        secondaryTagId: json["secondary_tag_id"] == null ? "0" : json["secondary_tag_id"].toString(),
        secondaryTag: json["secondary_tag"] ?? "",
        remark: json["remark"] ?? "",
        week: json["week"] == null ? "1" : json["week"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
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
