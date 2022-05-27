// To parse this JSON data, do
//
//     final getCustomerTypeResponse = getCustomerTypeResponseFromMap(jsonString);

import 'dart:convert';

class GetCustomerTypeResponse {
  GetCustomerTypeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<CustomerType> data;

  factory GetCustomerTypeResponse.fromJson(String str) => GetCustomerTypeResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetCustomerTypeResponse.fromMap(Map<String, dynamic> json) => GetCustomerTypeResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "Data not found",
        data: json["data"] == null ? [] : List<CustomerType>.from(json["data"].map((x) => CustomerType.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success ?? false,
        "message": message ?? "",
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class CustomerType {
  CustomerType({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory CustomerType.fromJson(String str) => CustomerType.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerType.fromMap(Map<String, dynamic> json) => CustomerType(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
