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
  List<LanguageModel>? data;

  factory SelectLanguageResponse.fromJson(String str) => SelectLanguageResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectLanguageResponse.fromMap(Map<String, dynamic> json) => SelectLanguageResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "Something went wrong",
        data: json["data"] == null ? null : List<LanguageModel>.from(json["data"].map((x) => LanguageModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class LanguageModel {
  LanguageModel({
    required this.id,
    required this.languageName,
  });

  int id;
  String languageName;

  factory LanguageModel.fromJson(String str) => LanguageModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LanguageModel.fromMap(Map<String, dynamic> json) => LanguageModel(
        id: json["id"] ?? 0,
        languageName: json["name"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": languageName,
      };
}
