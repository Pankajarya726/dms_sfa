import 'dart:convert';

class LoginResponse {
  LoginResponse({
    required this.success,
    required this.message,
    required this.id,
    required this.accessToken,
    required this.tokenType,
    required this.isLeader,
    required this.startMyDay,
  });

  bool success;
  String message;
  int id;
  String accessToken;
  String tokenType;
  bool isLeader;
  String startMyDay;

  factory LoginResponse.fromJson(String str) => LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"].toString(),
        id: json["id"] == null ? 0 : json["id"],
        accessToken: json["access_token"] == null ? "" : json["access_token"].toString(),
        tokenType: json["token_type"] == null ? "" : json["token_type"].toString(),
        isLeader: json["is_leader"] == null ? false : json["is_leader"],
        startMyDay: json["startMyDay"] == null ? "" : json["startMyDay"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "id": id == null ? null : id,
        "access_token": accessToken == null ? null : accessToken,
        "token_type": tokenType == null ? null : tokenType,
        "is_leader": isLeader == null ? null : isLeader,
        "startMyDay": startMyDay == null ? null : startMyDay,
      };
}
