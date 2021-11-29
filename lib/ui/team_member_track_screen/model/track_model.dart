// To parse this JSON data, do
//
//     final trackResponse = trackResponseFromMap(jsonString);

import 'dart:convert';

class TrackResponse {
  TrackResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<TrackData> data;

  factory TrackResponse.fromJson(String str) =>
      TrackResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TrackResponse.fromMap(Map<String, dynamic> json) => TrackResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<TrackData>.from(
                json["data"].map((x) => TrackData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class TrackData {
  TrackData({
    required this.userId,
    required this.inOutStatus,
    required this.inOutDate,
    required this.clockInLatitude,
    required this.clockInLongitude,
    required this.clockOutLatitude,
    required this.clockOutLongitude,
  });

  int userId;
  int inOutStatus;
  DateTime? inOutDate;
  String clockInLatitude;
  String clockInLongitude;
  String clockOutLatitude;
  String clockOutLongitude;

  factory TrackData.fromJson(String str) => TrackData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TrackData.fromMap(Map<String, dynamic> json) => TrackData(
        userId: json["user_id"] == null ? 0 : json["user_id"],
        inOutStatus: json["in_out_status"] == null ? 0 : json["in_out_status"],
        inOutDate: json["in_out_date"] == null
            ? null
            : DateTime.parse(json["in_out_date"]),
        clockInLatitude: json["clock_in_latitude"] == null
            ? ""
            : json["clock_in_latitude"].toString(),
        clockInLongitude: json["clock_in_longitude"] == null
            ? ""
            : json["clock_in_longitude"].toString(),
        clockOutLatitude: json["clock_out_latitude"] == null
            ? ""
            : json["clock_out_latitude"].toString(),
        clockOutLongitude: json["clock_out_longitude"] == null
            ? ""
            : json["clock_out_longitude"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId == null ? 0 : userId,
        "in_out_status": inOutStatus == null ? 0 : inOutStatus,
        "in_out_date": inOutDate == null
            ? ""
            : "${inOutDate!.year.toString().padLeft(4, '0')}-${inOutDate!.month.toString().padLeft(2, '0')}-${inOutDate!.day.toString().padLeft(2, '0')}",
        "clock_in_latitude": clockInLatitude == null ? "" : clockInLatitude,
        "clock_in_longitude": clockInLongitude == null ? "" : clockInLongitude,
        "clock_out_latitude": clockOutLatitude == null ? "" : clockOutLatitude,
        "clock_out_longitude":
            clockOutLongitude == null ? "" : clockOutLongitude,
      };
}
