// To parse this JSON data, do
//
//     final addPlanUpdateDataResponse = addPlanUpdateDataResponseFromMap(jsonString);

import 'dart:convert';

class AddPlanUpdateDataResponse {
  AddPlanUpdateDataResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory AddPlanUpdateDataResponse.fromJson(String str) =>
      AddPlanUpdateDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddPlanUpdateDataResponse.fromMap(Map<String, dynamic> json) =>
      AddPlanUpdateDataResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
