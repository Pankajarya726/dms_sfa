import 'dart:convert';

class ChangePassResponse {
  ChangePassResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory ChangePassResponse.fromJson(String str) =>
      ChangePassResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChangePassResponse.fromMap(Map<String, dynamic> json) =>
      ChangePassResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
