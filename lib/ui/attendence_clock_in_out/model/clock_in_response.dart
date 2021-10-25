// To parse this JSON data, do
//
//     final clockInResponse = clockInResponseFromMap(jsonString);

import 'dart:convert';

class ClockInResponse {
  ClockInResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory ClockInResponse.fromJson(String str) =>
      ClockInResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClockInResponse.fromMap(Map<String, dynamic> json) => ClockInResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
