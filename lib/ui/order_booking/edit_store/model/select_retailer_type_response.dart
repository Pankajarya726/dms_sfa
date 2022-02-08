import 'dart:convert';

class SelectRetailerTypeResponse {
  SelectRetailerTypeResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum>? data;

  factory SelectRetailerTypeResponse.fromJson(String str) =>
      SelectRetailerTypeResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectRetailerTypeResponse.fromMap(Map<String, dynamic> json) =>
      SelectRetailerTypeResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
