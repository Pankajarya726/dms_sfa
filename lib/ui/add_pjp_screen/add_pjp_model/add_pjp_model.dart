import 'dart:convert';

class AddPjpResponse {
  AddPjpResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  Data? data;

  factory AddPjpResponse.fromJson(String str) =>
      AddPjpResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddPjpResponse.fromMap(Map<String, dynamic> json) => AddPjpResponse(
        success: json["success"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data!.toMap(),
      };
}

class Data {
  Data({
    required this.userId,
    required this.pjpDescription,
    required this.pjpDate,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  String userId;
  String pjpDescription;
  DateTime pjpDate;
  int status;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        pjpDescription: json["pjp_description"],
        pjpDate: DateTime.parse(json["pjp_date"]),
        status: json["status"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "pjp_description": pjpDescription,
        "pjp_date":
            "${pjpDate.year.toString().padLeft(4, '0')}-${pjpDate.month.toString().padLeft(2, '0')}-${pjpDate.day.toString().padLeft(2, '0')}",
        "status": status,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
