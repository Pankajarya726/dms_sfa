// To parse this JSON data, do
//
//     final selectBeatResponse = selectBeatResponseFromMap(jsonString);

import 'dart:convert';

import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';

class SelectBeatResponse {
  SelectBeatResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<BeatsModal>? data;

  factory SelectBeatResponse.fromJson(String str) => SelectBeatResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectBeatResponse.fromMap(Map<String, dynamic> json) => SelectBeatResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? [] : List<BeatsModal>.from(json["data"].map((x) => BeatsModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}
