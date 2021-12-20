import 'dart:convert';

class SplashResponse {
  SplashResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.startMyDay,
  });

  bool success;
  String message;
  Data? data;
  String startMyDay;

  factory SplashResponse.fromJson(String str) =>
      SplashResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SplashResponse.fromMap(Map<String, dynamic> json) => SplashResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
        startMyDay: json["StartMyDay"] == null ? null : json["StartMyDay"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
        "StartMyDay": startMyDay == null ? null : startMyDay,
      };
}

class Data {
  Data({
    required this.id,
    required this.appVersion,
    required this.deviceType,
    required this.downloadLink,
    required this.isMandatory,
  });

  int id;
  String appVersion;
  int deviceType;
  dynamic downloadLink;
  int isMandatory;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        appVersion: json["app_version"] == null ? null : json["app_version"],
        deviceType: json["device_type"] == null ? null : json["device_type"],
        downloadLink: json["download_link"],
        isMandatory: json["isMandatory"] == null ? null : json["isMandatory"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "app_version": appVersion == null ? null : appVersion,
        "device_type": deviceType == null ? null : deviceType,
        "download_link": downloadLink,
        "isMandatory": isMandatory == null ? null : isMandatory,
      };
}
