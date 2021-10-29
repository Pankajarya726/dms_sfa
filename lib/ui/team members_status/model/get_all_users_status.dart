// To parse this JSON data, do
//
//     final getAllUsersStatusResponse = getAllUsersStatusResponseFromMap(jsonString);

import 'dart:convert';

class GetAllUsersStatusResponse {
  GetAllUsersStatusResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  Data? data;

  factory GetAllUsersStatusResponse.fromJson(String str) =>
      GetAllUsersStatusResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllUsersStatusResponse.fromMap(Map<String, dynamic> json) =>
      GetAllUsersStatusResponse(
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
    required this.clockInAppr,
    required this.clockInReject,
    required this.absentReject,
    required this.absentApproved,
  });

  List<AbsentApproved> clockInAppr;
  List<AbsentApproved> clockInReject;
  List<AbsentApproved> absentReject;
  List<AbsentApproved> absentApproved;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        clockInAppr: json["clock_in_appr"] == null
            ? []
            : List<AbsentApproved>.from(
                json["clock_in_appr"].map((x) => AbsentApproved.fromMap(x))),
        clockInReject: json["clock_in_reject"] == null
            ? []
            : List<AbsentApproved>.from(
                json["clock_in_reject"].map((x) => AbsentApproved.fromMap(x))),
        absentReject: json["absent_reject"] == null
            ? []
            : List<AbsentApproved>.from(
                json["absent_reject"].map((x) => AbsentApproved.fromMap(x))),
        absentApproved: json["absent_approved"] == null
            ? []
            : List<AbsentApproved>.from(
                json["absent_approved"].map((x) => AbsentApproved.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "clock_in_appr": clockInAppr == null
            ? []
            : List<dynamic>.from(clockInAppr.map((x) => x.toMap())),
        "clock_in_reject": clockInReject == null
            ? []
            : List<dynamic>.from(clockInReject.map((x) => x.toMap())),
        "absent_reject": absentReject == null
            ? []
            : List<dynamic>.from(absentReject.map((x) => x.toMap())),
        "absent_approved": absentApproved == null
            ? []
            : List<dynamic>.from(absentApproved.map((x) => x.toMap())),
      };
}

class AbsentApproved {
  AbsentApproved({
    required this.userId,
    required this.name,
  });

  int userId;
  String name;

  factory AbsentApproved.fromJson(String str) =>
      AbsentApproved.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AbsentApproved.fromMap(Map<String, dynamic> json) => AbsentApproved(
        userId: json["user_id"] == null ? null : json["user_id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId == null ? null : userId,
        "name": name == null ? null : name,
      };
}

class AttendanceStatusModel {
  String status;
  int userId;
  String userName;
  int approveStatus;
  AttendanceStatusModel(
      {required this.approveStatus,
      required this.status,
      required this.userId,
      required this.userName});
}
