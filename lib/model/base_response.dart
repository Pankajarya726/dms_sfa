import 'dart:convert';

class BaseResponse {
  BaseResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory BaseResponse.fromJson(String str) => BaseResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BaseResponse.fromMap(Map<String, dynamic> json) => BaseResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
      };
}
