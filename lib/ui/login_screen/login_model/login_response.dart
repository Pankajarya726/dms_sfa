import 'dart:convert';

import 'package:dms/ui/splash_screen/model/splash_model.dart';

class LoginResponse {
  LoginResponse({
    required this.success,
    required this.message,
    required this.id,
    required this.accessToken,
    required this.tokenType,
    required this.isLeader,
    required this.startMyDay,
    this.pjpButton,
  });

  bool success;
  String message;
  int id;
  String accessToken;
  String tokenType;
  bool isLeader;
  String startMyDay;
  PjpButton? pjpButton;
  factory LoginResponse.fromJson(String str) => LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        success: json["success"] ?? false,
        message: json["message"] == null ? "" : json["message"].toString(),
        id: json["id"] ?? 0,
        accessToken: json["access_token"] == null ? "" : json["access_token"].toString(),
        tokenType: json["token_type"] == null ? "" : json["token_type"].toString(),
        isLeader: json["is_leader"] ?? false,
        startMyDay: json["startMyDay"] ?? "hide",
        pjpButton: json["pjpbutton"] == null
            ? PjpButton(addPjpButton: "0", fromDate: DateTime.now(), toDate: DateTime.now())
            : PjpButton.fromMap(json["pjpbutton"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "id": id,
        "access_token": accessToken,
        "token_type": tokenType,
        "is_leader": isLeader,
        "startMyDay": startMyDay,
      };
}
