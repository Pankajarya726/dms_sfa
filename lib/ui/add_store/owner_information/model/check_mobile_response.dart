import 'dart:convert';

class CheckMobileResponse {
  CheckMobileResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory CheckMobileResponse.fromJson(String str) =>
      CheckMobileResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CheckMobileResponse.fromMap(Map<String, dynamic> json) =>
      CheckMobileResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
      };
}
