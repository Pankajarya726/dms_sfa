// To parse this JSON data, do
//
//     final endMyDayResponse = endMyDayResponseFromMap(jsonString);

import 'dart:convert';

import 'package:dms/model/get_all_tag_response.dart';

class EndMyDayResponse {
  EndMyDayResponse({
    required this.success,
    required this.message,
    required this.status,
    this.data,
  });

  bool success;
  String message;
  String status;
  StartDayData? data;

  factory EndMyDayResponse.fromJson(String str) => EndMyDayResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EndMyDayResponse.fromMap(Map<String, dynamic> json) => EndMyDayResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        status: json["status"] == null ? "0" : json["status"].toString(),
        data: json["data"] == null ? null : StartDayData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "status": status,
        "data": data == null ? null : data!.toMap(),
      };
}

class StartDayData {
  StartDayData({
    required this.primaryTag,
    required this.secondaryTag,
  });

  PrimaryTag primaryTag;
  List<SecondaryTag> secondaryTag;

  factory StartDayData.fromJson(String str) => StartDayData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StartDayData.fromMap(Map<String, dynamic> json) => StartDayData(
        primaryTag: PrimaryTag.fromMap(json["primary_tag"]),
        secondaryTag:
            json["secondary_tag"] == null ? [] : List<SecondaryTag>.from(json["secondary_tag"].map((x) => SecondaryTag.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "primary_tag": primaryTag,
        "secondary_tag": secondaryTag,
      };
}
