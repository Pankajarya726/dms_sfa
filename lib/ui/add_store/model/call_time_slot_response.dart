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

  factory CallTimeSlotResponse.fromJson(String str) =>
      CallTimeSlotResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CallTimeSlotResponse.fromMap(Map<String, dynamic> json) =>
      CallTimeSlotResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<CallTimeSlotModel>.from(
                json["data"].map((x) => CallTimeSlotModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class CallTimeSlotModel {
  CallTimeSlotModel({
    required this.id,
    required this.from,
    required this.to,
  });

  int id;
  String from;
  String to;

  factory CallTimeSlotModel.fromJson(String str) =>
      CallTimeSlotModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CallTimeSlotModel.fromMap(Map<String, dynamic> json) =>
      CallTimeSlotModel(
        id: json["id"] == null ? null : json["id"],
        from: json["from"] == null ? null : json["from"],
        to: json["to"] == null ? null : json["to"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "from": from == null ? null : from,
        "to": to == null ? null : to,
      };
}
