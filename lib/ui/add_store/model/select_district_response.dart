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

  factory SelectDistrictResponse.fromJson(String str) => SelectDistrictResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectDistrictResponse.fromMap(Map<String, dynamic> json) => SelectDistrictResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "Something went wrong",
        data: json["data"] == null ? [] : List<DistrictModel>.from(json["data"].map((x) => DistrictModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class DistrictModel {
  DistrictModel({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory DistrictModel.fromJson(String str) => DistrictModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DistrictModel.fromMap(Map<String, dynamic> json) => DistrictModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
