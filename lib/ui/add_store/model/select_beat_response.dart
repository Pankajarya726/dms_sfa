// To parse this JSON data, do
//
//     final selectBeatResponse = selectBeatResponseFromMap(jsonString);

import 'dart:convert';

class SelectBeatResponse {
  SelectBeatResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<BeatModal>? data;

  factory SelectBeatResponse.fromJson(String str) =>
      SelectBeatResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectBeatResponse.fromMap(Map<String, dynamic> json) =>
      SelectBeatResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<BeatModal>.from(
                json["data"].map((x) => BeatModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class BeatModal {
  BeatModal({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory BeatModal.fromJson(String str) => BeatModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BeatModal.fromMap(Map<String, dynamic> json) => BeatModal(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
