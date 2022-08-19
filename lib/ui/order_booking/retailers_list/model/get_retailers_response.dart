// To parse this JSON data, do
//
//     final getRetailersResponse = getRetailersResponseFromMap(jsonString);

import 'dart:convert';

class GetRetailersResponse {
  GetRetailersResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<RetailersModal>? data;

  factory GetRetailersResponse.fromJson(String str) => GetRetailersResponse.fromMap(json.decode(str));

  factory GetRetailersResponse.fromMap(Map<String, dynamic> json) => GetRetailersResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? [] : List<RetailersModal>.from(json["data"].map((x) => RetailersModal.fromMap(x))),
      );
}

class RetailersModal {
  RetailersModal({
    required this.orderStatus,
    required this.customerId,
    required this.userId,
    required this.uniqueCode,
    required this.name,
    required this.outlatName,
    required this.customerType,
    required this.primaryMobile,
    required this.secondaryMobile,
    required this.email,
    required this.primaryAddress,
    required this.retailerTypeId,
    required this.retailerCategory,
    required this.enrollmentTypeId,
    required this.landmark,
    required this.locationId,
    required this.beatId,
    required this.beatName,
    required this.districtId,
    required this.lng,
    required this.lat,
    required this.outletPicture,
    required this.distance,
  });

  int orderStatus;
  String customerId;
  String userId;
  String uniqueCode;
  String name;
  String outlatName;
  String customerType;
  String primaryMobile;
  String secondaryMobile;
  String email;
  String primaryAddress;
  String retailerTypeId;
  String retailerCategory;
  String enrollmentTypeId;
  String landmark;
  String locationId;
  String beatId;
  String beatName;
  String districtId;
  String lng;
  String lat;
  String outletPicture;
  String distance;

  factory RetailersModal.fromJson(String str) => RetailersModal.fromMap(json.decode(str));

  factory RetailersModal.fromMap(Map<String, dynamic> json) => RetailersModal(
        orderStatus: json["order_status"] ?? 0,
        customerId: json["customer_id"] == null ? "" : json["customer_id"].toString(),
        userId: json["user_id"] == null ? "" : json["user_id"].toString(),
        uniqueCode: json["unique_code"] == null ? "" : json["unique_code"].toString(),
        name: json["name"] == null ? "" : json["name"].toString(),
        outlatName: json["outlat_name"] == null ? "" : json["outlat_name"].toString(),
        customerType: json["customer_type"] == null ? "" : json["customer_type"].toString(),
        primaryMobile: json["primary_mobile"] == null ? "" : json["primary_mobile"].toString(),
        secondaryMobile: json["secondary_mobile"] == null ? "" : json["secondary_mobile"].toString(),
        email: json["email"] == null ? "" : json["email"].toString(),
        primaryAddress: json["primary_address"] == null ? "" : json["primary_address"].toString(),
        retailerTypeId: json["retailer_type_id"] == null ? "" : json["retailer_type_id"].toString(),
        retailerCategory: json["retailer_category"] == null ? "" : json["retailer_category"].toString(),
        enrollmentTypeId: json["enrollment_type_id"] == null ? "" : json["enrollment_type_id"].toString(),
        landmark: json["landmark"] == null ? "" : json["landmark"].toString(),
        locationId: json["location_id"] == null ? "" : json["location_id"].toString(),
        beatId: json["beat_id"] == null ? "" : json["beat_id"].toString(),
        beatName: json["beat_name"] == null ? "" : json["beat_name"].toString(),
        districtId: json["district_id"] == null ? "" : json["district_id"].toString(),
        lng: json["lng"] == null ? "0.0" : json["lng"].toString(),
        lat: json["lat"] == null ? "0.0" : json["lat"].toString(),
        outletPicture: json["outlet_picture"] == null ? "" : json["outlet_picture"].toString(),
        distance: json["distance"] == null ? "0.0" : json["distance"].toString(),
      );

  setDistance(String distance) {
    this.distance = distance;
  }

  @override
  String toString() {
    return 'RetailersModal{orderStatus: $orderStatus, customerId: $customerId, userId: $userId, uniqueCode: $uniqueCode, name: $name, outlatName: $outlatName, customerType: $customerType, primaryMobile: $primaryMobile, secondaryMobile: $secondaryMobile, email: $email, primaryAddress: $primaryAddress, retailerTypeId: $retailerTypeId, retailerCategory: $retailerCategory, enrollmentTypeId: $enrollmentTypeId, landmark: $landmark, locationId: $locationId, beatId: $beatId, beatName: $beatName, districtId: $districtId, lng: $lng, lat: $lat, outletPicture: $outletPicture, distance: $distance}';
  }
}
