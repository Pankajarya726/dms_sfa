// To parse this JSON data, do
//
//     final userData = userDataFromMap(jsonString);

import 'dart:convert';

class UserData {
  UserData({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data? data;

  factory UserData.fromJson(String str) => UserData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data! == null ? null : data!.toMap(),
      };
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.image,
    required this.designation,
    required this.clockIn,
    required this.clockOut,
    required this.pjpButton,
  });

  int id;
  String name;
  String email;
  String mobileNumber;
  String image;
  String designation;
  List<ClockIn> clockIn;
  List<ClockOut> clockOut;
  String pjpButton;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        mobileNumber:
            json["mobile_number"] == null ? null : json["mobile_number"],
        image: json["image"] == null ? null : json["image"],
        designation: json["designation"] == null ? null : json["designation"],
        clockIn: json["clockIn"] == null
            ? []
            : List<ClockIn>.from(
                json["clockIn"].map((x) => ClockIn.fromMap(x))),
        clockOut: json["clockOut"] == null
            ? []
            : List<ClockOut>.from(
                json["clockOut"].map((x) => ClockOut.fromMap(x))),
        pjpButton: json["pjp_button"] == null ? null : json["pjp_button"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "mobile_number": mobileNumber == null ? null : mobileNumber,
        "image": image == null ? null : image,
        "designation": designation == null ? null : designation,
        "clockIn": clockIn == null
            ? null
            : List<dynamic>.from(clockIn.map((x) => x.toMap())),
        "clockOut": clockOut == null
            ? null
            : List<dynamic>.from(clockOut.map((x) => x.toMap())),
        "pjp_button": pjpButton == null ? null : pjpButton,
      };
}

class ClockIn {
  ClockIn({
    required this.inOutStatus,
    required this.inOutTime,
    required this.userId,
  });

  int inOutStatus;
  String inOutTime;
  int userId;

  factory ClockIn.fromJson(String str) => ClockIn.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClockIn.fromMap(Map<String, dynamic> json) => ClockIn(
        inOutStatus:
            json["in_out_status"] == null ? null : json["in_out_status"],
        inOutTime: json["in_out_time"] == null ? null : json["in_out_time"],
        userId: json["user_id"] == null ? null : json["user_id"],
      );

  Map<String, dynamic> toMap() => {
        "in_out_status": inOutStatus == null ? null : inOutStatus,
        "in_out_time": inOutTime == null ? null : inOutTime,
        "user_id": userId == null ? null : userId,
      };
}

class ClockOut {
  ClockOut({
    required this.inOutStatus,
    required this.inOutTime,
  });

  int inOutStatus;
  String inOutTime;

  factory ClockOut.fromJson(String str) => ClockOut.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClockOut.fromMap(Map<String, dynamic> json) => ClockOut(
        inOutStatus:
            json["in_out_status"] == null ? null : json["in_out_status"],
        inOutTime: json["in_out_time"] == null ? null : json["in_out_time"],
      );

  Map<String, dynamic> toMap() => {
        "in_out_status": inOutStatus == null ? null : inOutStatus,
        "in_out_time": inOutTime == null ? null : inOutTime,
      };
}
