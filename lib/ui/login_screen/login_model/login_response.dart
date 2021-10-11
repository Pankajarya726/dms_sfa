import 'dart:convert';

class LoginResponse {
  LoginResponse({
    required this.success,
    required this.message,
    required this.id,
    required this.accessToken,
    required this.tokenType,
  });

  bool success;
  String message;
  int id;
  String accessToken;
  String tokenType;

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        success: json["success"],
        message: json["message"],
        id: json["id"],
        accessToken: json["access_token"],
        tokenType: json["token_type"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "id": id,
        "access_token": accessToken,
        "token_type": tokenType,
      };
}
