import 'dart:convert';

class PjpResponse {
  PjpResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<PjpData>? data;

  factory PjpResponse.fromJson(String str) =>
      PjpResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PjpResponse.fromMap(Map<String, dynamic> json) => PjpResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<PjpData>.from(json["data"].map((x) => PjpData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class PjpData {
  PjpData({
    required this.userId,
    required this.pjpDate,
    required this.pjpDescription,
    required this.id,
  });

  int userId;
  DateTime? pjpDate;
  String pjpDescription;
  int id;

  factory PjpData.fromJson(String str) => PjpData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PjpData.fromMap(Map<String, dynamic> json) => PjpData(
        userId: json["user_id"] == null ? null : json["user_id"],
        pjpDate:
            json["pjp_date"] == null ? null : DateTime.parse(json["pjp_date"]),
        pjpDescription:
            json["pjp_description"] == null ? null : json["pjp_description"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId == null ? null : userId,
        "pjp_date": pjpDate == null
            ? null
            : "${pjpDate!.year.toString().padLeft(4, '0')}-${pjpDate!.month.toString().padLeft(2, '0')}-${pjpDate!.day.toString().padLeft(2, '0')}",
        "pjp_description": pjpDescription == null ? null : pjpDescription,
        "id": id == null ? null : id,
      };
}
