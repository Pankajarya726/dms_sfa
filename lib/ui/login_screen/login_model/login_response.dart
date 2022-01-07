// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromMap(jsonString);

import 'dart:convert';

class LoginResponse {
  LoginResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  LoginData? data;

  factory LoginResponse.fromJson(String str) => LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? null : LoginData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : data!.toMap(),
      };
}

class LoginData {
  LoginData({
    required this.id,
    required this.accessToken,
    required this.tokenType,
    required this.isLeader,
    required this.startMyDay,
    required this.pjpButton,
  });

  int id;
  String accessToken;
  String tokenType;
  bool isLeader;
  String startMyDay;
  PjpButton pjpButton;

  factory LoginData.fromJson(String str) => LoginData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginData.fromMap(Map<String, dynamic> json) => LoginData(
        id: json["id"],
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        isLeader: json["is_leader"],
        startMyDay: json["startMyDay"],
        pjpButton: json["pjpbutton"] == null
            ? PjpButton(fromDate: DateTime.now(), toDate: DateTime.now(), addPjpButton: 0)
            : PjpButton.fromMap(json["pjpbutton"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "access_token": accessToken,
        "token_type": tokenType,
        "is_leader": isLeader,
        "startMyDay": startMyDay,
        "pjpbutton": pjpButton == null ? null : pjpButton.toMap(),
      };
}

class PjpButton {
  PjpButton({
    required this.addPjpButton,
    required this.fromDate,
    required this.toDate,
  });

  int addPjpButton;
  DateTime fromDate;
  DateTime toDate;

  factory PjpButton.fromJson(String str) => PjpButton.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PjpButton.fromMap(Map<String, dynamic> json) => PjpButton(
        addPjpButton: json["addpjpbutton"] ?? "",
        fromDate: json["fromDate"] == null ? DateTime.now() : DateTime.parse(json["fromDate"]),
        toDate: json["toDate"] == null ? DateTime.now() : DateTime.parse(json["toDate"]),
      );

  Map<String, dynamic> toMap() => {
        "addpjpbutton": addPjpButton,
        "fromDate": fromDate == null
            ? null
            : "${fromDate.year.toString().padLeft(4, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
        "toDate": toDate == null
            ? null
            : "${toDate.year.toString().padLeft(4, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}",
      };
}
