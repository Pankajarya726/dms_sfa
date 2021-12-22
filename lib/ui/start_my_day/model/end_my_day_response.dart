// To parse this JSON data, do
//
//     final endMyDayResponse = endMyDayResponseFromMap(jsonString);

import 'dart:convert';

class EndMyDayResponse {
  EndMyDayResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory EndMyDayResponse.fromJson(String str) =>
      EndMyDayResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EndMyDayResponse.fromMap(Map<String, dynamic> json) =>
      EndMyDayResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
