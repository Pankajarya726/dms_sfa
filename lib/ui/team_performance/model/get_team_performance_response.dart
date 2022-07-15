// To parse this JSON data, do
//
//     final getTeamPerformanceResponse = getTeamPerformanceResponseFromMap(jsonString);

import 'dart:convert';

class GetTeamPerformanceResponse {
  GetTeamPerformanceResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  TeamPerformance? data;

  factory GetTeamPerformanceResponse.fromJson(String str) => GetTeamPerformanceResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetTeamPerformanceResponse.fromMap(Map<String, dynamic> json) => GetTeamPerformanceResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "Something went wrong",
        data: json["data"] == null ? null : TeamPerformance.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : data!.toMap(),
      };
}

class TeamPerformance {
  TeamPerformance({
    required this.coWorker,
    required this.totalCall,
    required this.totalProductive,
    required this.conversion,
    required this.totalSale,
    required this.averageValue,
    required this.totalEnrollment,
    required this.presentDays,
    required this.pendingTask,
    required this.completedTask,
    required this.teamMember,
  });

  String coWorker;
  String totalCall;
  String totalProductive;
  String conversion;
  String totalSale;
  String averageValue;
  String totalEnrollment;
  String presentDays;
  String pendingTask;
  String completedTask;
  List<TeamMember> teamMember;

  factory TeamPerformance.fromJson(String str) => TeamPerformance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TeamPerformance.fromMap(Map<String, dynamic> json) => TeamPerformance(
        coWorker: json["co_worker"] == null ? "" : json["co_worker"].toString(),
        totalCall: json["total_call"] == null ? "" : json["total_call"].toString(),
        totalProductive: json["total_productive"] == null ? "" : json["total_productive"].toString(),
        conversion: json["conversion"] == null ? "" : json["conversion"].toString(),
        totalSale: json["total_sale"] == null ? "" : json["total_sale"].toString(),
        averageValue: json["average_value"] == null ? "" : json["average_value"].toString(),
        totalEnrollment: json["total_enrollment"] == null ? "" : json["total_enrollment"].toString(),
        presentDays: json["present_days"] == null ? "" : json["present_days"].toString(),
        pendingTask: json["pending_task"] == null ? "" : json["pending_task"].toString(),
        completedTask: json["completed_task"] == null ? "" : json["completed_task"].toString(),
        teamMember: json["team_member"] == null ? [] : List<TeamMember>.from(json["team_member"].map((x) => TeamMember.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "co_worker": coWorker,
        "total_call": totalCall,
        "total_productive": totalProductive,
        "conversion": conversion,
        "total_sale": totalSale,
        "average_value": averageValue,
        "total_enrollment": totalEnrollment,
        "present_days": presentDays,
        "pending_task": pendingTask,
        "completed_task": completedTask,
        "team_member": teamMember == null ? null : List<dynamic>.from(teamMember.map((x) => x.toMap())),
      };
}

class TeamMember {
  TeamMember({
    required this.userId,
    required this.name,
    required this.designation,
  });

  String userId;
  String name;
  String designation;

  factory TeamMember.fromJson(String str) => TeamMember.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TeamMember.fromMap(Map<String, dynamic> json) => TeamMember(
        userId: json["user_id"] == null ? "0" : json["user_id"].toString(),
        name: json["name"] ?? "",
        designation: json["designation"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "name": name,
        "designation": designation,
      };
}
