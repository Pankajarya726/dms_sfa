import 'dart:convert';

class ReportResponse {
  ReportResponse({
    required this.success,
    required this.data,
  });

  bool success;
  List<ReportData>? data;

  factory ReportResponse.fromJson(String str) =>
      ReportResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReportResponse.fromMap(Map<String, dynamic> json) => ReportResponse(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null
            ? null
            : List<ReportData>.from(
                json["data"].map((x) => ReportData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class ReportData {
  ReportData({
    required this.name,
    required this.primaryContactNo,
    required this.designation,
    required this.date,
    required this.attendanceStatus,
    required this.pjp,
    required this.workingPlan,
    required this.clockInTime,
    required this.clockOutTime,
    required this.comment,
    required this.statusApproved,
  });

  String name;
  String primaryContactNo;
  String designation;
  String date;
  String attendanceStatus;
  String pjp;
  String workingPlan;
  String clockInTime;
  String clockOutTime;
  String comment;
  String statusApproved;

  factory ReportData.fromJson(String str) =>
      ReportData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReportData.fromMap(Map<String, dynamic> json) => ReportData(
        name: json["name"] == null ? "" : json["name"].toString(),
        primaryContactNo: json["primary_contact_no"] == null
            ? ""
            : json["primary_contact_no"].toString(),
        designation:
            json["designation"] == null ? "" : json["designation"].toString(),
        date: json["date"] == null ? "" : json["date"].toString(),
        attendanceStatus: json["attendance_status"] == null
            ? ""
            : json["attendance_status"].toString(),
        pjp: json["pjp"] == null ? "" : json["pjp"].toString(),
        workingPlan:
            json["working_plan"] == null ? "" : json["working_plan"].toString(),
        clockInTime: json["clock_in_time"] == null
            ? ""
            : json["clock_in_time"].toString(),
        clockOutTime: json["clock_out_time"] == null
            ? ""
            : json["clock_out_time"].toString(),
        comment: json["comment"] == null ? "" : json["comment"].toString(),
        statusApproved: json["status_approved"] == null
            ? ""
            : json["status_approved"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "name": name == null ? null : name,
        "primary_contact_no":
            primaryContactNo == null ? null : primaryContactNo,
        "designation": designation == null ? null : designation,
        "date": date == null ? null : date,
        "attendance_status": attendanceStatus == null ? null : attendanceStatus,
        "pjp": pjp == null ? null : pjp,
        "working_plan": workingPlan == null ? null : workingPlan,
        "clock_in_time": clockInTime == null ? null : clockInTime,
        "clock_out_time": clockOutTime == null ? null : clockOutTime,
        "comment": comment == null ? null : comment,
        "status_approved": statusApproved == null ? null : statusApproved,
      };
}
