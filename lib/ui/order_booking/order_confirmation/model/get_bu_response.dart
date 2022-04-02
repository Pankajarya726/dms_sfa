import 'dart:convert';

class GetBuResponse {
  GetBuResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<BUModal>? data;

  factory GetBuResponse.fromJson(String str) => GetBuResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetBuResponse.fromMap(Map<String, dynamic> json) => GetBuResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? [] : List<BUModal>.from(json["data"].map((x) => BUModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class BUModal {
  BUModal({
    required this.id,
    required this.businessUnit,
  });

  String id;
  String businessUnit;
  bool selected = false;

  factory BUModal.fromJson(String str) => BUModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BUModal.fromMap(Map<String, dynamic> json) => BUModal(
        id: json["id"] == null ? "" : json["id"].toString(),
        businessUnit: json["business_unit"] == null ? "" : json["business_unit"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "business_unit": businessUnit,
      };
}
