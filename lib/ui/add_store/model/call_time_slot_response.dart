import 'dart:convert';

class CallTimeSlotResponse {
  CallTimeSlotResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<CallTimeSlotModel>? data;

  factory CallTimeSlotResponse.fromJson(String str) => CallTimeSlotResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CallTimeSlotResponse.fromMap(Map<String, dynamic> json) => CallTimeSlotResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? [] : List<CallTimeSlotModel>.from(json["data"].map((x) => CallTimeSlotModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class CallTimeSlotModel {
  CallTimeSlotModel({
    required this.id,
    required this.from,
    required this.to,
    this.time = "",
  });

  int id;
  String from;
  String to;
  String time;

  factory CallTimeSlotModel.fromJson(String str) => CallTimeSlotModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CallTimeSlotModel.fromMap(Map<String, dynamic> json) => CallTimeSlotModel(
        id: json["id"] ?? 0,
        from: json["from"] == null ? "" : json["from"].toString(),
        to: json["to"] == null ? "" : json["to"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "from": from,
        "to": to,
      };
}
