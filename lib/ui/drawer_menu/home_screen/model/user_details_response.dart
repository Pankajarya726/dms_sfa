import 'dart:convert';

class GetUserResponse {
  GetUserResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  UserDetails? data;

  factory GetUserResponse.fromJson(String str) => GetUserResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetUserResponse.fromMap(Map<String, dynamic> json) => GetUserResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : UserDetails.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : data!.toMap(),
      };
}

class UserDetails {
  UserDetails({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.image,
    required this.designation,
    required this.clockInOutData,
    required this.pjpDescription,
    required this.pjpButton,
    required this.startMyDay,
  });

  int id;
  String name;
  String email;
  String mobileNumber;
  String image;
  String designation;
  List<ClockInOutData> clockInOutData;
  String pjpDescription;
  String pjpButton;
  String startMyDay;

  factory UserDetails.fromJson(String str) => UserDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserDetails.fromMap(Map<String, dynamic> json) => UserDetails(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        mobileNumber: json["mobile_number"] ?? "",
        image: json["image"] ?? "",
        designation: json["designation"] ?? "",
        clockInOutData: json["clockInOutData"] == null
            ? []
            : List<ClockInOutData>.from(json["clockInOutData"].map((x) => ClockInOutData.fromMap(x))),
        pjpDescription: json["pjp_description"] ?? "",
        pjpButton: json["pjp_button"] ?? "hide",
        startMyDay: json["startMyday"] ?? "hide",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile_number": mobileNumber,
        "image": image,
        "designation": designation,
        "clockInOutData": clockInOutData,
        "pjp_description": pjpDescription,
        "pjp_button": pjpButton,
        "startMyday": startMyDay,
      };
}

class ClockInOutData {
  ClockInOutData({
    required this.inOutStatus,
    required this.absentReason,
    required this.clockInTime,
    required this.clockOutTime,
    required this.userId,
    required this.comment,
    required this.clockOutImage,
  });

  int inOutStatus;
  String absentReason;
  String clockInTime;
  dynamic clockOutTime;
  int userId;
  String comment;
  String clockOutImage;

  factory ClockInOutData.fromJson(String str) => ClockInOutData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClockInOutData.fromMap(Map<String, dynamic> json) => ClockInOutData(
        inOutStatus: json["in_out_status"] ?? 0,
        absentReason: json["absent_reason"] == null ? "" : json["absent_reason"].toString(),
        clockInTime: json["clock_in_time"] == null ? "" : json["clock_in_time"].toString(),
        clockOutTime: json["clock_out_time"],
        userId: json["user_id"] ?? 0,
        comment: json["comment"] == null ? "" : json["comment"].toString(),
        clockOutImage: json["clock_out_image"] == null ? "" : json["clock_out_image"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "in_out_status": inOutStatus,
        "absent_reason": absentReason,
        "clock_in_time": clockInTime,
        "clock_out_time": clockOutTime,
        "user_id": userId,
        "comment": comment,
        "clock_out_image": clockOutImage,
      };
}
