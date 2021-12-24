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
  String pjpButton;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        startMyDay: json["StartMyDay"] ?? "hide",
        pjpButton: json["pjpbutton"] ?? "hide",
        isMandatory: json["isMandatory"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "isMandatory": isMandatory,
      };
}
