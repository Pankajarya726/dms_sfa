// To parse this JSON data, do
//
//     final selectLanguageResponse = selectLanguageResponseFromMap(jsonString);

import 'dart:convert';

class SelectLanguageResponse {
  SelectLanguageResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum>? data;

  factory SelectLanguageResponse.fromJson(String str) =>
      SelectLanguageResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectLanguageResponse.fromMap(Map<String, dynamic> json) =>
      SelectLanguageResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.languageName,
  });

  int id;
  String languageName;

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        languageName:
            json["language_name"] == null ? null : json["language_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "language_name": languageName == null ? null : languageName,
      };
}
