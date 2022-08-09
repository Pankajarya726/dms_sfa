import 'dart:convert';

class GetOrderSummeryResponse {
  GetOrderSummeryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<OrderSummery> data;

  factory GetOrderSummeryResponse.fromJson(String str) => GetOrderSummeryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetOrderSummeryResponse.fromMap(Map<String, dynamic> json) => GetOrderSummeryResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? [] : List<OrderSummery>.from(json["data"].map((x) => OrderSummery.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class OrderSummery {
  OrderSummery({
    required this.customerId,
    required this.customerName,
    required this.date,
    required this.districtId,
    required this.districtName,
    required this.cityId,
    required this.cityName,
    required this.beatId,
    required this.beatName,
    required this.totalAmount,
    required this.tc,
    required this.pc,
    required this.avg,
    required this.pdfLink,
  });

  String customerId;
  String customerName;
  DateTime date;
  String districtId;
  String districtName;
  String cityId;
  String cityName;
  String beatId;
  String beatName;
  String totalAmount;
  String tc;
  String pc;
  String avg;
  String pdfLink;

  factory OrderSummery.fromJson(String str) => OrderSummery.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderSummery.fromMap(Map<String, dynamic> json) => OrderSummery(
        customerId: json["customer_id"] == null ? "" : json["customer_id"].toString(),
        customerName: json["customer_name"] == null ? "" : json["customer_name"].toString(),
        date: json["date"] == null ? DateTime.now() : DateTime.parse(json["date"]),
        districtId: json["district_id"] == null ? "" : json["district_id"].toString(),
        districtName: json["district_name"] == null ? "" : json["district_name"].toString(),
        cityId: json["city_id"] == null ? "" : json["city_id"].toString(),
        cityName: json["city_name"] == null ? "" : json["city_name"].toString(),
        beatId: json["beat_id"] == null ? "" : json["beat_id"].toString(),
        beatName: json["beat_name"] == null ? "" : json["beat_name"].toString(),
        totalAmount: json["total_amount"] == null ? "" : json["total_amount"].toString(),
        tc: json["tc"] == null ? "" : json["tc"].toString(),
        pc: json["pc"] == null ? "" : json["pc"].toString(),
        avg: json["avg"] == null ? "" : json["avg"].toString(),
        pdfLink: json["pdf_link"] == null ? "" : json["pdf_link"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "customer_id": customerId,
        "customer_name": customerName,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "district_id": districtId,
        "district_name": districtName,
        "city_id": cityId,
        "city_name": cityName,
        "beat_id": beatId,
        "beat_name": beatName,
        "total_amount": totalAmount,
        "tc": tc,
        "pc": pc,
        "avg": avg,
        "pdf_link": pdfLink,
      };
}
