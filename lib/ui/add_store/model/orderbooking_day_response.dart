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
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<OrderBookingDayModal>.from(
                json["data"].map((x) => OrderBookingDayModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
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

  String id;
  String orderBookingDay1;
  String orderBookingDay2;

  factory OrderBookingDayModal.fromJson(String str) =>
      OrderBookingDayModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderBookingDayModal.fromMap(Map<String, dynamic> json) =>
      OrderBookingDayModal(
        id: json["id"] == null ? "" : json["id"].toString(),
        orderBookingDay1: json["order_booking_day1"] == null
            ? ""
            : json["order_booking_day1"].toString(),
        orderBookingDay2: json["order_booking_day2"] == null
            ? ""
            : json["order_booking_day2"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "order_booking_day1": orderBookingDay1,
        "order_booking_day2": orderBookingDay2,
      };
}
