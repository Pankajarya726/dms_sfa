import 'dart:convert';

class ForgotPasswordResponse {
  ForgotPasswordResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory ForgotPasswordResponse.fromJson(String str) =>
      ForgotPasswordResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ForgotPasswordResponse.fromMap(Map<String, dynamic> json) =>
      ForgotPasswordResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
