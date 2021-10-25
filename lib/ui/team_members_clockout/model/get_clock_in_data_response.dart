import 'dart:convert';

class GetClockInDataResponse {
  GetClockInDataResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<GetClockInData>? data;

  factory GetClockInDataResponse.fromJson(String str) =>
      GetClockInDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetClockInDataResponse.fromMap(Map<String, dynamic> json) =>
      GetClockInDataResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<GetClockInData>.from(
                json["data"].map((x) => GetClockInData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class GetClockInData {
  GetClockInData({
    required this.id,
    required this.userId,
    required this.inOutTime,
    required this.inOutDate,
    required this.inOutStatus,
    required this.name,
  });

  int id;
  int userId;
  String inOutTime;
  DateTime? inOutDate;
  int inOutStatus;
  String name;

  factory GetClockInData.fromJson(String str) =>
      GetClockInData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetClockInData.fromMap(Map<String, dynamic> json) => GetClockInData(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        inOutTime: json["in_out_time"] == null ? null : json["in_out_time"],
        inOutDate: json["in_out_date"] == null
            ? null
            : DateTime.parse(json["in_out_date"]),
        inOutStatus:
            json["in_out_status"] == null ? null : json["in_out_status"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "in_out_time": inOutTime == null ? null : inOutTime,
        "in_out_date": inOutDate == null
            ? null
            : "${inOutDate!.year.toString().padLeft(4, '0')}-${inOutDate!.month.toString().padLeft(2, '0')}-${inOutDate!.day.toString().padLeft(2, '0')}",
        "in_out_status": inOutStatus == null ? null : inOutStatus,
        "name": name == null ? null : name,
      };
}
