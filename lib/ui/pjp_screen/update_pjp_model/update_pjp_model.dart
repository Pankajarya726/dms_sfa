import 'dart:convert';

class UpdateResponce {
  UpdateResponce({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory UpdateResponce.fromJson(String str) =>
      UpdateResponce.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpdateResponce.fromMap(Map<String, dynamic> json) => UpdateResponce(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
