// To parse this JSON data, do
//
//     final clockOutResponse = clockOutResponseFromMap(jsonString);

import 'dart:convert';

class ClockOutResponse {
  ClockOutResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory ClockOutResponse.fromJson(String str) =>
      ClockOutResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClockOutResponse.fromMap(Map<String, dynamic> json) =>
      ClockOutResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
