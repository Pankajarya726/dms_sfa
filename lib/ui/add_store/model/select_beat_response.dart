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
        success: json["success"] ?? false,
        message: json["message"] ?? "Something went wrong",
        data: json["data"] == null ? [] : List<BeatsModal>.from(json["data"].map((x) => BeatsModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}
