import 'dart:convert';

class LoginResponse {
  LoginResponse({
    required this.success,
    required this.message,
    required this.id,
    required this.accessToken,
    required this.tokenType,
    required this.isLeader,
  });

  bool success;
  String message;
  int id;
  String accessToken;
  String tokenType;
  bool isLeader;

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        id: json["id"] == null ? null : json["id"],
        accessToken: json["access_token"] == null ? null : json["access_token"],
        tokenType: json["token_type"] == null ? null : json["token_type"],
        isLeader: json["is_leader"] == null ? null : json["is_leader"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "id": id == null ? null : id,
        "access_token": accessToken == null ? null : accessToken,
        "token_type": tokenType == null ? null : tokenType,
        "is_leader": isLeader == null ? null : isLeader,
      };
}
