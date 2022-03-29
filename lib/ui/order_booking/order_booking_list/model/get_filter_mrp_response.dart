import 'dart:convert';

class GetFilterMrpResponse {
  GetFilterMrpResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<FilterMrpModal>? data;

  factory GetFilterMrpResponse.fromJson(String str) =>
      GetFilterMrpResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetFilterMrpResponse.fromMap(Map<String, dynamic> json) =>
      GetFilterMrpResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<FilterMrpModal>.from(
                json["data"].map((x) => FilterMrpModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class FilterMrpModal {
  FilterMrpModal({
    required this.id,
    required this.mrp,
  });

  String id;
  String mrp;

  factory FilterMrpModal.fromJson(String str) =>
      FilterMrpModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FilterMrpModal.fromMap(Map<String, dynamic> json) => FilterMrpModal(
        id: json["id"] == null ? "" : json["id"].toString(),
        mrp: json["mrp"] == null ? "" : json["mrp"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "mrp": mrp,
      };
}
