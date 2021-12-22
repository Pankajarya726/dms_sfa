// To parse this JSON data, do
//
//     final secondaryTagResponse = secondaryTagResponseFromMap(jsonString);

import 'dart:convert';

class SecondaryTagResponse {
  SecondaryTagResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  SecondaryTagDataModel? data;

  factory SecondaryTagResponse.fromJson(String str) => SecondaryTagResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SecondaryTagResponse.fromMap(Map<String, dynamic> json) => SecondaryTagResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? null : SecondaryTagDataModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class SecondaryTagDataModel {
  SecondaryTagDataModel({
    required this.primaryTag,
    this.location,
    this.jointWorker,
  });

  String primaryTag;
  List<SecondaryTag>? location;
  List<SecondaryTag>? jointWorker;

  factory SecondaryTagDataModel.fromJson(String str) => SecondaryTagDataModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SecondaryTagDataModel.fromMap(Map<String, dynamic> json) => SecondaryTagDataModel(
        primaryTag: json["Primary_tag"] == null ? "" : json["Primary_tag"],
        location: json["location"] == null ? [] : List<SecondaryTag>.from(json["location"].map((x) => SecondaryTag.fromMap(x))),
        jointWorker: json["data"] == null ? [] : List<SecondaryTag>.from(json["data"].map((x) => SecondaryTag.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "Primary_tag": primaryTag == null ? null : primaryTag,
        "location": location == null ? null : List<dynamic>.from(location!.map((x) => x.toMap())),
      };
}

class SecondaryTag {
  SecondaryTag({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory SecondaryTag.fromJson(String str) => SecondaryTag.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SecondaryTag.fromMap(Map<String, dynamic> json) => SecondaryTag(
        id: json["id"] == null ? 0 : json["id"],
        name: json["name"] == null ? "" : json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
