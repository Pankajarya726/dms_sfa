// To parse this JSON data, do
//
//     final addPlanResponse = addPlanResponseFromMap(jsonString);

import 'dart:convert';

class AddPlanResponse {
  AddPlanResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory AddPlanResponse.fromJson(String str) => AddPlanResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddPlanResponse.fromMap(Map<String, dynamic> json) => AddPlanResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
