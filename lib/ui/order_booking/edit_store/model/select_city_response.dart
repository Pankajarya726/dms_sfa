import 'dart:convert';

class SelectCityResponse {
  SelectCityResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<CityModel>? data;

  factory SelectCityResponse.fromJson(String str) =>
      SelectCityResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectCityResponse.fromMap(Map<String, dynamic> json) =>
      SelectCityResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<CityModel>.from(
                json["data"].map((x) => CityModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class CityModel {
  CityModel({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory CityModel.fromJson(String str) => CityModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CityModel.fromMap(Map<String, dynamic> json) => CityModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
