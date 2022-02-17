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
    required this.userId,
    required this.name,
    required this.customerCodes,
  });

  int id;
  int userId;
  String name;
  String customerCodes;

  factory DistributorModel.fromJson(String str) =>
      DistributorModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DistributorModel.fromMap(Map<String, dynamic> json) =>
      DistributorModel(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        name: json["name"] == null ? null : json["name"],
        customerCodes:
            json["customer_codes"] == null ? null : json["customer_codes"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "name": name == null ? null : name,
        "customer_codes": customerCodes == null ? null : customerCodes,
      };
}
