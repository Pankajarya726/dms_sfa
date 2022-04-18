import 'dart:convert';

class TaskEscalateResponse {
  TaskEscalateResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory TaskEscalateResponse.fromJson(String str) =>
      TaskEscalateResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaskEscalateResponse.fromMap(Map<String, dynamic> json) =>
      TaskEscalateResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
      };
}
