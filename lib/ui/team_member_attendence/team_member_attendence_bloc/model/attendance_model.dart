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
  List<ClockInData>? clockInData;
  List<AbsentData>? absentData;

  factory AttendanceResponse.fromJson(String str) =>
      AttendanceResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AttendanceResponse.fromMap(Map<String, dynamic> json) =>
      AttendanceResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        clockInData: json["clock_in_data"] == null
            ? null
            : List<ClockInData>.from(
                json["clock_in_data"].map((x) => ClockInData.fromMap(x))),
        absentData: json["absent_data"] == null
            ? null
            : List<AbsentData>.from(
                json["absent_data"].map((x) => AbsentData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "clock_in_data": clockInData == null
            ? []
            : List<dynamic>.from(clockInData!.map((x) => x.toMap())),
        "absent_data": absentData == null
            ? []
            : List<dynamic>.from(absentData!.map((x) => x.toMap())),
      };
}

class AbsentData {
  AbsentData({
    required this.userId,
    required this.absentStatus,
    required this.absentDate,
    required this.status,
  });

  int userId;
  int absentStatus;
  DateTime? absentDate;
  String status;

  factory AbsentData.fromJson(String str) =>
      AbsentData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AbsentData.fromMap(Map<String, dynamic> json) => AbsentData(
        userId: json["user-id"] == null ? null : json["user-id"],
        absentStatus:
            json["absent_status"] == null ? null : json["absent_status"],
        absentDate: json["absent_date"] == null
            ? null
            : DateTime.parse(json["absent_date"]),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toMap() => {
        "user-id": userId == null ? null : userId,
        "absent_status": absentStatus == null ? null : absentStatus,
        "absent_date": absentDate == null
            ? null
            : "${absentDate!.year.toString().padLeft(4, '0')}-${absentDate!.month.toString().padLeft(2, '0')}-${absentDate!.day.toString().padLeft(2, '0')}",
        "status": status == null ? null : status,
      };
}

class ClockInData {
  ClockInData({
    required this.userId,
    required this.status,
    required this.clockInStatus,
    required this.inOutDate,
  });

  int userId;
  String status;
  int clockInStatus;
  DateTime? inOutDate;

  factory ClockInData.fromJson(String str) =>
      ClockInData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClockInData.fromMap(Map<String, dynamic> json) => ClockInData(
        userId: json["user_id"] == null ? null : json["user_id"],
        status: json["status"] == null ? null : json["status"],
        clockInStatus:
            json["clockIn_status"] == null ? null : json["clockIn_status"],
        inOutDate: json["in_out_date"] == null
            ? null
            : DateTime.parse(json["in_out_date"]),
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId == null ? null : userId,
        "status": status == null ? null : status,
        "clockIn_status": clockInStatus == null ? null : clockInStatus,
        "in_out_date": inOutDate == null
            ? null
            : "${inOutDate!.year.toString().padLeft(4, '0')}-${inOutDate!.month.toString().padLeft(2, '0')}-${inOutDate!.day.toString().padLeft(2, '0')}",
      };
}
