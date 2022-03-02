import 'dart:convert';

import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';

class RetailersResponse {
  RetailersResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<RetailersModal>? data;

  factory RetailersResponse.fromJson(String str) => RetailersResponse.fromMap(json.decode(str));

  factory RetailersResponse.fromMap(Map<String, dynamic> json) => RetailersResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<RetailersModal>.from(json["data"].map((x) => RetailersModal.fromMap(x))),
      );
}
