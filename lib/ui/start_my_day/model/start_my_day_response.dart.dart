// To parse this JSON data, do
//
//     final startMyDayResponse = startMyDayResponseFromMap(jsonString);

import 'dart:convert';

class StartMyDayResponse {
  StartMyDayResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory StartMyDayResponse.fromJson(String str) => StartMyDayResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StartMyDayResponse.fromMap(Map<String, dynamic> json) => StartMyDayResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
      };
}
