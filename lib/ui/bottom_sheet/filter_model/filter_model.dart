import 'dart:convert';

class FiltersResponse {
  FiltersResponse({
    required this.success,
    required this.data,
  });

  bool success;
  List<FilterData>? data;

  factory FiltersResponse.fromJson(String str) =>
      FiltersResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FiltersResponse.fromMap(Map<String, dynamic> json) => FiltersResponse(
        success: json["success"] == null ? false : json["success"],
        data: json["data"] == null
            ? []
            : List<FilterData>.from(
                json["data"].map((x) => FilterData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class FilterData {
  FilterData({
    required this.id,
    required this.name,
    required this.zoneId,
  });

  String id;
  String name;
  String zoneId;

  factory FilterData.fromJson(String str) =>
      FilterData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FilterData.fromMap(Map<String, dynamic> json) => FilterData(
        id: json["id"] == null ? "" : json["id"].toString(),
        name: json["name"] == null ? "" : json["name"].toString(),
        zoneId: json["zone_id"] == null ? "" : json["zone_id"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? "" : id,
        "name": name == null ? null : name,
        "zone_id": zoneId == null ? null : zoneId,
      };
}
