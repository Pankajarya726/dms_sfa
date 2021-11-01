import 'dart:convert';

class EditProfileResponse {
  EditProfileResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory EditProfileResponse.fromJson(String str) =>
      EditProfileResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EditProfileResponse.fromMap(Map<String, dynamic> json) =>
      EditProfileResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
