import 'dart:convert';

class ClockInApproveRes {
  ClockInApproveRes({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory ClockInApproveRes.fromJson(String str) =>
      ClockInApproveRes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClockInApproveRes.fromMap(Map<String, dynamic> json) =>
      ClockInApproveRes(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
