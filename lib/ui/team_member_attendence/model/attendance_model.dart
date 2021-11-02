import 'dart:convert';

class AttendanceResponse {
  AttendanceResponse({
    required this.success,
    required this.message,
    required this.clockInData,
  });

  bool success;
  String message;
  List<ClockInData>? clockInData;

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
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "clock_in_data": clockInData == null
            ? null
            : List<dynamic>.from(clockInData!.map((x) => x.toMap())),
      };
}

class ClockInData {
  ClockInData({
    required this.id,
    required this.userId,
    required this.status,
    required this.approvedStatus,
    required this.date,
  });

  int id;
  int userId;
  String status;
  int approvedStatus;
  DateTime? date;

  factory ClockInData.fromJson(String str) =>
      ClockInData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClockInData.fromMap(Map<String, dynamic> json) => ClockInData(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        status: json["status"] == null ? null : json["status"],
        approvedStatus:
            json["approved_status"] == null ? null : json["approved_status"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "status": status == null ? null : status,
        "approved_status": approvedStatus == null ? null : approvedStatus,
        "date": date == null
            ? null
            : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}
