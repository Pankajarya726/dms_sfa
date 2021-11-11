import 'dart:convert';

class FiltersResponse {
  FiltersResponse({
    required this.success,
    required this.data,
  });

  int success;
  List<FilterData>? data;

  factory FiltersResponse.fromJson(String str) =>
      FiltersResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FiltersResponse.fromMap(Map<String, dynamic> json) => FiltersResponse(
        success: json["success"] == "" ? null : json["success"],
        data: json["data"] == null
            ? []
            : List<FilterData>.from(
                json["data"].map((x) => FilterData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class FilterData {
  FilterData({
    required this.id,
    required this.name,
    required this.stateId,
  });

  int id;
  String name;
  int stateId;

  factory FilterData.fromJson(String str) =>
      FilterData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FilterData.fromMap(Map<String, dynamic> json) => FilterData(
        id: json["id"] == "" ? null : json["id"],
        name: json["name"] == "" ? null : json["name"],
        stateId: json["state_id"] == "" ? null : json["state_id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "state_id": stateId == null ? null : stateId,
      };
}
