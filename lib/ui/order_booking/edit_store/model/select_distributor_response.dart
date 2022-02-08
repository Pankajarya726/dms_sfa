import 'dart:convert';

class SelectDistributorResponse {
  SelectDistributorResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<DistributorModel>? data;

  factory SelectDistributorResponse.fromJson(String str) =>
      SelectDistributorResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectDistributorResponse.fromMap(Map<String, dynamic> json) =>
      SelectDistributorResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<DistributorModel>.from(
                json["data"].map((x) => DistributorModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class DistributorModel {
  DistributorModel({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory DistributorModel.fromJson(String str) =>
      DistributorModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DistributorModel.fromMap(Map<String, dynamic> json) =>
      DistributorModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
