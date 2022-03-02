import 'dart:convert';

import 'package:dms/model/get_plan_response.dart';

class AddPlanResponse {
  AddPlanResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  PlanDataModel? data;

  factory AddPlanResponse.fromJson(String str) => AddPlanResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddPlanResponse.fromMap(Map<String, dynamic> json) => AddPlanResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : PlanDataModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : data!.toMap(),
      };
}
