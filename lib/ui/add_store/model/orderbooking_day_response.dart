// To parse this JSON data, do
//
//     final OrderBookingDayResponse = OrderBookingDayResponseFromMap(jsonString);

import 'dart:convert';

class OrderBookingDayResponse {
  OrderBookingDayResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<OrderBookingDayModal>? data;

  factory OrderBookingDayResponse.fromJson(String str) =>
      OrderBookingDayResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderBookingDayResponse.fromMap(Map<String, dynamic> json) =>
      OrderBookingDayResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<OrderBookingDayModal>.from(
                json["data"].map((x) => OrderBookingDayModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class OrderBookingDayModal {
  OrderBookingDayModal({
    required this.id,
    required this.orderBookingDay1,
    required this.orderBookingDay2,
  });

  int id;
  String orderBookingDay1;
  String orderBookingDay2;

  factory OrderBookingDayModal.fromJson(String str) =>
      OrderBookingDayModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderBookingDayModal.fromMap(Map<String, dynamic> json) =>
      OrderBookingDayModal(
        id: json["id"] == null ? null : json["id"],
        orderBookingDay1: json["order_booking_day1"] == null
            ? null
            : json["order_booking_day1"],
        orderBookingDay2: json["order_booking_day2"] == null
            ? null
            : json["order_booking_day2"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "order_booking_day1":
            orderBookingDay1 == null ? null : orderBookingDay1,
        "order_booking_day2":
            orderBookingDay2 == null ? null : orderBookingDay2,
      };
}
