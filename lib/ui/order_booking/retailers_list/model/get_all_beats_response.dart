// To parse this JSON data, do
//
//     final getAllBeatsResponse = getAllBeatsResponseFromMap(jsonString);

import 'dart:convert';

class GetAllBeatsResponse {
  GetAllBeatsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<BeatsModal>? data;

  factory GetAllBeatsResponse.fromJson(String str) => GetAllBeatsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllBeatsResponse.fromMap(Map<String, dynamic> json) => GetAllBeatsResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? [] : List<BeatsModal>.from(json["data"].map((x) => BeatsModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class BeatsModal {
  BeatsModal({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory BeatsModal.fromJson(String str) => BeatsModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BeatsModal.fromMap(Map<String, dynamic> json) => BeatsModal(
        id: json["id"] == null ? "" : json["id"].toString(),
        name: json["name"] == null ? "" : json["name"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
