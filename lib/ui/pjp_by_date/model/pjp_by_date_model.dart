import 'dart:convert';

class PjpByDateResponse {
  PjpByDateResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<PjpByDate>? data;

  factory PjpByDateResponse.fromJson(String str) =>
      PjpByDateResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PjpByDateResponse.fromMap(Map<String, dynamic> json) =>
      PjpByDateResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<PjpByDate>.from(
                json["data"].map((x) => PjpByDate.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class PjpByDate {
  PjpByDate({
    required this.clockInTime,
    required this.clockOutTime,
    required this.workingPlan,
    required this.approvedStatus,
    required this.pjpDescription,
  });

  String clockInTime;
  String clockOutTime;
  String workingPlan;
  int approvedStatus;
  String pjpDescription;

  factory PjpByDate.fromJson(String str) => PjpByDate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PjpByDate.fromMap(Map<String, dynamic> json) => PjpByDate(
        clockInTime:
            json["clock_in_time"] == null ? null : json["clock_in_time"],
        clockOutTime:
            json["clock_out_time"] == null ? null : json["clock_out_time"],
        workingPlan: json["working_plan"] == null ? null : json["working_plan"],
        approvedStatus:
            json["approved_status"] == null ? null : json["approved_status"],
        pjpDescription:
            json["pjp_description"] == null ? null : json["pjp_description"],
      );

  Map<String, dynamic> toMap() => {
        "clock_in_time": clockInTime == null ? null : clockInTime,
        "clock_out_time": clockOutTime == null ? null : clockOutTime,
        "working_plan": workingPlan == null ? null : workingPlan,
        "approved_status": approvedStatus == null ? null : approvedStatus,
        "pjp_description": pjpDescription == null ? null : pjpDescription,
      };
}
