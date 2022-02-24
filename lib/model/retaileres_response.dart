import 'dart:convert';

class RetailersResponse {
  RetailersResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<Retailers>? data;

  factory RetailersResponse.fromJson(String str) => RetailersResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RetailersResponse.fromMap(Map<String, dynamic> json) => RetailersResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Retailers>.from(json["data"].map((x) => Retailers.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Retailers {
  Retailers({
    required this.id,
    required this.userId,
    required this.uniqueCode,
    required this.customerName,
    required this.outletName,
    required this.connectionStatus,
    required this.beatId,
    required this.beatName,
    required this.districtId,
    required this.primaryAddress,
    required this.lat,
    required this.lng,
    required this.enrollmentTypeId,
    required this.primaryMobile,
    required this.secondaryMobile,
    required this.outletPicture,
  });

  int id;
  int userId;
  String uniqueCode;
  String customerName;
  String outletName;
  int connectionStatus;
  int beatId;
  String beatName;
  int districtId;
  String primaryAddress;
  String lat;
  String lng;
  int enrollmentTypeId;
  String primaryMobile;
  String secondaryMobile;
  String outletPicture;

  factory Retailers.fromJson(String str) => Retailers.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Retailers.fromMap(Map<String, dynamic> json) => Retailers(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        uniqueCode: json["unique_code"] ?? "",
        customerName: json["customer_name"] ?? "",
        outletName: json["outlat_name"] ?? "",
        connectionStatus: json["connection_status"] ?? 0,
        districtId: json["district_id"] ?? 0,
        beatId: json["beat_id"] ?? 0,
        primaryAddress: json["primary_address"] ?? "",
        beatName: json["beat_name"] ?? "",
        lat: json["lat"] ?? "0.0",
        lng: json["lng"] ?? "0.0",
        enrollmentTypeId: json["enrollment_type_id"] ?? 0,
        primaryMobile: json["primary_mobile"] ?? "",
        secondaryMobile: json["secondary_mobile"] ?? "",
        outletPicture: json["outlet_picture"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "unique_code": uniqueCode,
        "customer_name": customerName,
        "outlat_name": outletName,
        "district_id": districtId,
        "primary_address": primaryAddress,
        "lat": lat,
        "lng": lng,
        "enrollment_type_id": enrollmentTypeId,
        "primary_mobile": primaryMobile,
        "secondary_mobile": secondaryMobile,
        "outlet_picture": outletPicture,
      };
}
