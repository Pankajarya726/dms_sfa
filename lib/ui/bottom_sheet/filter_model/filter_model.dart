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
            ? null
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

  int id;
  String name;
  int zoneId;

  factory FilterData.fromJson(String str) =>
      FilterData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FilterData.fromMap(Map<String, dynamic> json) => FilterData(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        zoneId: json["zone_id"] == null ? null : json["zone_id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "zone_id": zoneId == null ? null : zoneId,
      };
}
