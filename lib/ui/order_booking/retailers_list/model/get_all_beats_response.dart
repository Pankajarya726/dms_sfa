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
  List<GetAllBeatsModal>? data;

  factory GetAllBeatsResponse.fromJson(String str) =>
      GetAllBeatsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllBeatsResponse.fromMap(Map<String, dynamic> json) =>
      GetAllBeatsResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<GetAllBeatsModal>.from(
                json["data"].map((x) => GetAllBeatsModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class GetAllBeatsModal {
  GetAllBeatsModal({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory GetAllBeatsModal.fromJson(String str) =>
      GetAllBeatsModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllBeatsModal.fromMap(Map<String, dynamic> json) =>
      GetAllBeatsModal(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
