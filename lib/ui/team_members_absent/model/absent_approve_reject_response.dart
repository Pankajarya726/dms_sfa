// To parse this JSON data, do
//
//     final absentApproveRejectResponse = absentApproveRejectResponseFromMap(jsonString);

import 'dart:convert';

class AbsentApproveRejectResponse {
  AbsentApproveRejectResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory AbsentApproveRejectResponse.fromJson(String str) =>
      AbsentApproveRejectResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AbsentApproveRejectResponse.fromMap(Map<String, dynamic> json) =>
      AbsentApproveRejectResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
