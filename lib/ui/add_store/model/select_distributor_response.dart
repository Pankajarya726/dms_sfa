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

  factory SelectDistributorResponse.fromJson(String str) => SelectDistributorResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectDistributorResponse.fromMap(Map<String, dynamic> json) => SelectDistributorResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "Something went wrong",
        data: json["data"] == null ? [] : List<DistributorModel>.from(json["data"].map((x) => DistributorModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class DistributorModel {
  DistributorModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.customerCodes,
  });

  int id;
  int userId;
  String name;
  String customerCodes;

  factory DistributorModel.fromJson(String str) => DistributorModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DistributorModel.fromMap(Map<String, dynamic> json) => DistributorModel(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        name: json["name"] == null ? "" : json["name"].toString(),
        customerCodes: json["customer_codes"] == null ? "" : json["customer_codes"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "customer_codes": customerCodes,
      };
}
