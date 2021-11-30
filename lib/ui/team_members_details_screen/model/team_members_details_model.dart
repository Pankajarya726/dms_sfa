// To parse this JSON data, do
//
//     final detailsStatusResponse = detailsStatusResponseFromMap(jsonString);

import 'dart:convert';

class DetailsStatusResponse {
  DetailsStatusResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data? data;

  factory DetailsStatusResponse.fromJson(String str) =>
      DetailsStatusResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetailsStatusResponse.fromMap(Map<String, dynamic> json) =>
      DetailsStatusResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class Data {
  Data({
    required this.clockInTime,
    required this.clockOutTime,
    required this.inDate,
    required this.inWorkingPlan,
    required this.pjpDescription,
    required this.inImage,
    required this.comments,
    required this.outImage,
    required this.absentReason,
  });

  String clockInTime;
  String clockOutTime;
  DateTime? inDate;
  String inWorkingPlan;
  String pjpDescription;
  String inImage;
  String comments;
  String outImage;
  String absentReason;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        clockInTime: json["clock_in_time"] == null
            ? ""
            : json["clock_in_time"].toString(),
        clockOutTime: json["clock_out_time"] == null
            ? ""
            : json["clock_out_time"].toString(),
        inDate: json["in_date"] == null
            ? DateTime.parse("")
            : DateTime.parse(json["in_date"]),
        inWorkingPlan: json["in_working_plan"] == null
            ? ""
            : json["in_working_plan"].toString(),
        pjpDescription: json["pjp_description"] == null
            ? ""
            : json["pjp_description"].toString(),
        inImage: json["in_image"] == null ? "" : json["in_image"].toString(),
        comments: json["comments"] == null ? "" : json["comments"].toString(),
        outImage: json["out_image"] == null ? "" : json["out_image"].toString(),
        absentReason: json["absent_reason"] == null
            ? ""
            : json["absent_reason"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "clock_in_time": clockInTime == null ? null : clockInTime,
        "clock_out_time": clockOutTime == null ? null : clockOutTime,
        "in_date": inDate == null
            ? null
            : "${inDate!.year.toString().padLeft(4, '0')}-${inDate!.month.toString().padLeft(2, '0')}-${inDate!.day.toString().padLeft(2, '0')}",
        "in_working_plan": inWorkingPlan == null ? null : inWorkingPlan,
        "pjp_description": pjpDescription == null ? null : pjpDescription,
        "in_image": inImage == null ? null : inImage,
        "comments": comments == null ? null : comments,
        "out_image": outImage == null ? null : outImage,
        "absent_reason": absentReason == null ? null : absentReason
      };
}
