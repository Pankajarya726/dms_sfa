// To parse this JSON data, do
//
//     final getTeamPerformanceResponse = getTeamPerformanceResponseFromMap(jsonString);

import 'dart:convert';

class GetMyPerformanceResponse {
  GetMyPerformanceResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  MyPerformance? data;

  factory GetMyPerformanceResponse.fromJson(String str) => GetMyPerformanceResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetMyPerformanceResponse.fromMap(Map<String, dynamic> json) => GetMyPerformanceResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "Something went wrong",
        data: json["data"] == null ? null : MyPerformance.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : data!.toMap(),
      };
}

class MyPerformance {
  MyPerformance({
    required this.totalCall,
    required this.totalProductive,
    required this.conversion,
    required this.totalSale,
    required this.averageValue,
    required this.totalEnrollment,
    required this.numberOfDays,
    required this.presentDays,
    required this.pendingTask,
    required this.completedTask,
  });

  String totalCall;
  String totalProductive;
  String conversion;
  String totalSale;
  String averageValue;
  String totalEnrollment;
  String numberOfDays;
  String presentDays;
  String pendingTask;
  String completedTask;

  factory MyPerformance.fromJson(String str) => MyPerformance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyPerformance.fromMap(Map<String, dynamic> json) => MyPerformance(
        totalCall: json["total_call"] == null ? "" : json["total_call"].toString(),
        totalProductive: json["total_productive"] == null ? "" : json["total_productive"].toString(),
        conversion: json["conversion"] == null ? "" : json["conversion"].toString(),
        totalSale: json["total_sale"] == null ? "" : json["total_sale"].toString(),
        averageValue: json["average_value"] == null ? "" : json["average_value"].toString(),
        totalEnrollment: json["total_enrollment"] == null ? "" : json["total_enrollment"].toString(),
        numberOfDays: json["number_of_days"] == null ? "" : json["number_of_days"].toString(),
        presentDays: json["present_days"] == null ? "" : json["present_days"].toString(),
        pendingTask: json["pending_task"] == null ? "" : json["pending_task"].toString(),
        completedTask: json["completed_task"] == null ? "" : json["completed_task"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "total_call": totalCall,
        "total_productive": totalProductive,
        "conversion": conversion,
        "total_sale": totalSale,
        "average_value": averageValue,
        "total_enrollment": totalEnrollment,
        "number_of_days": numberOfDays,
        "present_days": presentDays,
        "pending_task": pendingTask,
        "completed_task": completedTask,
      };
}
