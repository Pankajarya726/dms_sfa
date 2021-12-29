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
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : UserDetails.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
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
        id: json["id"] == null ? 0 : json["id"],
        name: json["name"] == null ? "" : json["name"],
        email: json["email"] == null ? "" : json["email"],
        mobileNumber: json["mobile_number"] == null ? "" : json["mobile_number"],
        image: json["image"] == null ? "" : json["image"],
        designation: json["designation"] == null ? "" : json["designation"],
        clockInOutData: json["clockInOutData"] == null
            ? []
            : List<ClockInOutData>.from(json["clockInOutData"].map((x) => ClockInOutData.fromMap(x))),
        pjpDescription: json["pjp_description"] == null ? "" : json["pjp_description"],
        pjpButton: json["pjp_button"] == null ? "hide" : json["pjp_button"],
        startMyDay: json["startMyday"] == null ? "hide" : json["startMyday"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "mobile_number": mobileNumber == null ? null : mobileNumber,
        "image": image == null ? null : image,
        "designation": designation == null ? null : designation,
        "clockInOutData": clockInOutData == null ? null : List<dynamic>.from(clockInOutData.map((x) => x.toMap())),
        "pjp_description": pjpDescription == null ? null : pjpDescription,
        "pjp_button": pjpButton == null ? null : pjpButton,
        "startMyday": startMyDay == null ? null : startMyDay,
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
        inOutStatus: json["in_out_status"] == null ? 0 : json["in_out_status"],
        absentReason: json["absent_reason"] == null ? "" : json["absent_reason"].toString(),
        clockInTime: json["clock_in_time"] == null ? "" : json["clock_in_time"].toString(),
        clockOutTime: json["clock_out_time"],
        userId: json["user_id"] == null ? 0 : json["user_id"],
        comment: json["comment"] == null ? "" : json["comment"].toString(),
        clockOutImage: json["clock_out_image"] == null ? "" : json["clock_out_image"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "in_out_status": inOutStatus == null ? null : inOutStatus,
        "absent_reason": absentReason == null ? null : absentReason,
        "clock_in_time": clockInTime == null ? null : clockInTime,
        "clock_out_time": clockOutTime,
        "user_id": userId == null ? null : userId,
        "comment": comment == null ? null : comment,
        "clock_out_image": clockOutImage == null ? null : clockOutImage,
      };
}
