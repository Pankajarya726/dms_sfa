import 'dart:convert';

class SelectDistrictResponse {
  SelectDistrictResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<DistrictModel>? data;

  factory SelectDistrictResponse.fromJson(String str) =>
      SelectDistrictResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectDistrictResponse.fromMap(Map<String, dynamic> json) =>
      SelectDistrictResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<DistrictModel>.from(
                json["data"].map((x) => DistrictModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class DistrictModel {
  DistrictModel({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory DistrictModel.fromJson(String str) =>
      DistrictModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DistrictModel.fromMap(Map<String, dynamic> json) => DistrictModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
