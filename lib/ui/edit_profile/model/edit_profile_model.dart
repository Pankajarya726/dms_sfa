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
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
      };
}
