// To parse this JSON data, do
//
//     final attendanceResponse = attendanceResponseFromMap(jsonString);

import 'dart:convert';

class AttendanceResponse {
  AttendanceResponse({
    required this.success,
    required this.message,
    required this.clockInData,
    required this.absentData,
  });

  bool success;
  String message;
  List<AttendenceModel>? clockInData;
  List<AttendenceModel>? absentData;

  factory AttendanceResponse.fromJson(String str) =>
      AttendanceResponse.fromMap(json.decode(str));

  factory AttendanceResponse.fromMap(Map<String, dynamic> json) =>
      AttendanceResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        clockInData: json["clock_in_data"] == null
            ? null
            : List<AttendenceModel>.from(
                json["clock_in_data"].map((x) => AttendenceModel.fromMap(x))),
        absentData: json["absent_data"] == null
            ? null
            : List<AttendenceModel>.from(
                json["absent_data"].map((x) => AttendenceModel.fromMap(x))),
      );
}

class AttendenceModel {
  AttendenceModel({
    required this.userId,
    required this.approvedStatus,
    required this.date,
    required this.status,
    required this.id,
  });

  int userId;
  int approvedStatus;
  String? date;
  String status;
  int id;

  factory AttendenceModel.fromJson(String str) =>
      AttendenceModel.fromMap(json.decode(str));

  factory AttendenceModel.fromMap(Map<String, dynamic> json) => AttendenceModel(
        userId: json["user_id"] == null ? null : json["user_id"],
        approvedStatus:
            json["approved_status"] == null ? null : json["approved_status"],
        date: json["date"] == null ? null : json["date"],
        status: json["status"] == null ? null : json["status"],
        id: json["id"] == null ? 0 : json["id"],
      );
}
