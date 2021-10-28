import 'dart:convert';

class TrackResponse {
  TrackResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<TrackData>? data;

  factory TrackResponse.fromJson(String str) =>
      TrackResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TrackResponse.fromMap(Map<String, dynamic> json) => TrackResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<TrackData>.from(
                json["data"].map((x) => TrackData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class TrackData {
  TrackData({
    required this.userId,
    required this.inOutStatus,
    required this.inOutDate,
    required this.latitude,
    required this.longitude,
  });

  int userId;
  int inOutStatus;
  DateTime? inOutDate;
  String latitude;
  String longitude;

  factory TrackData.fromJson(String str) => TrackData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TrackData.fromMap(Map<String, dynamic> json) => TrackData(
        userId: json["user_id"] == null ? null : json["user_id"],
        inOutStatus:
            json["in_out_status"] == null ? null : json["in_out_status"],
        inOutDate: json["in_out_date"] == null
            ? null
            : DateTime.parse(json["in_out_date"]),
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId == null ? null : userId,
        "in_out_status": inOutStatus == null ? null : inOutStatus,
        "in_out_date": inOutDate == null
            ? null
            : "${inOutDate!.year.toString().padLeft(4, '0')}-${inOutDate!.month.toString().padLeft(2, '0')}-${inOutDate!.day.toString().padLeft(2, '0')}",
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
      };
}
