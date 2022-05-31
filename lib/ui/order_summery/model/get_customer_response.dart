// To parse this JSON data, do
//
//     final getCustomerResponse = getCustomerResponseFromMap(jsonString);

import 'dart:convert';

class GetCustomerResponse {
  GetCustomerResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<Customer> data;

  factory GetCustomerResponse.fromJson(String str) => GetCustomerResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetCustomerResponse.fromMap(Map<String, dynamic> json) => GetCustomerResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "Data not found",
        data: json["data"] == null ? [] : List<Customer>.from(json["data"].map((x) => Customer.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Customer {
  Customer({
    required this.id,
    required this.uniqueCode,
    required this.customerName,
    required this.customerType,
    required this.zoneId,
    required this.stateId,
    required this.divisionId,
    required this.districtId,
    required this.cityId,
    required this.beatId,
  });

  String id;
  String uniqueCode;
  String customerName;
  String customerType;
  String zoneId;
  String stateId;
  String divisionId;
  String districtId;
  String cityId;
  String beatId;

  factory Customer.fromJson(String str) => Customer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Customer.fromMap(Map<String, dynamic> json) => Customer(
        id: json["id"] == null ? "0" : json["id"].toString(),
        uniqueCode: json["unique_code"] == null ? "0" : json["unique_code"].toString(),
        customerName: json["customer_name"] == null ? "" : json["customer_name"].toString(),
        customerType: json["customer_type"] == null ? "0" : json["customer_type"].toString(),
        zoneId: json["zone_id"] == null ? "0" : json["zone_id"].toString(),
        stateId: json["state_id"] == null ? "0" : json["state_id"].toString(),
        divisionId: json["division_id"] == null ? "0" : json["division_id"].toString(),
        districtId: json["district_id"] == null ? "0" : json["district_id"].toString(),
        cityId: json["city_id"] == null ? "0" : json["city_id"].toString(),
        beatId: json["beat_id"] == null ? "0" : json["beat_id"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "unique_code": uniqueCode,
        "customer_name": customerName,
        "customer_type": customerType,
        "zone_id": zoneId,
        "state_id": stateId,
        "division_id": divisionId,
        "district_id": districtId,
        "city_id": cityId,
        "beat_id": beatId,
      };
}
