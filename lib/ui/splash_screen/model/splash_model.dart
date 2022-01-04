// To parse this JSON data, do
//
//     final splashResponse = splashResponseFromMap(jsonString);

import 'dart:convert';

class SplashResponse {
  SplashResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  Data? data;

  factory SplashResponse.fromJson(String str) => SplashResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SplashResponse.fromMap(Map<String, dynamic> json) => SplashResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : data!.toMap(),
      };
}

class Data {
  Data({
    required this.isMandatory,
    required this.startMyDay,
    required this.pjpButton,
  });

  int isMandatory;
  String startMyDay;
  PjpButton pjpButton;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        isMandatory: json["isMandatory"] ?? 0,
        startMyDay: json["StartMyDay"] ?? "hide",
        pjpButton: json["pjpbutton"] == null
            ? PjpButton(addPjpButton: "0", fromDate: DateTime.now(), toDate: DateTime.now())
            : PjpButton.fromMap(json["pjpbutton"]),
      );

  Map<String, dynamic> toMap() => {
        "isMandatory": isMandatory,
        "StartMyDay": startMyDay,
        "pjpbutton": pjpButton == null ? null : pjpButton.toMap(),
      };
}

class PjpButton {
  PjpButton({
    required this.addPjpButton,
    required this.fromDate,
    required this.toDate,
  });

  String addPjpButton;
  DateTime fromDate;
  DateTime toDate;

  factory PjpButton.fromJson(String str) => PjpButton.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PjpButton.fromMap(Map<String, dynamic> json) => PjpButton(
        addPjpButton: json["addpjpbutton"] == null ? "0" : json["addpjpbutton"].toString(),
        fromDate: json["fromDate"] == null ? DateTime.now() : DateTime.parse(json["fromDate"]),
        toDate: json["toDate"] == null ? DateTime.now() : DateTime.parse(json["toDate"]),
      );

  Map<String, dynamic> toMap() => {
        "addpjpbutton": addPjpButton,
        "fromDate":
            "${fromDate.year.toString().padLeft(4, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
        "toDate":
            "${toDate.year.toString().padLeft(4, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}",
      };
}
