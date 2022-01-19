import 'dart:convert';

class GetAllTagResponse {
  GetAllTagResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<PrimaryTag> data;

  factory GetAllTagResponse.fromJson(String str) => GetAllTagResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllTagResponse.fromMap(Map<String, dynamic> json) => GetAllTagResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<PrimaryTag>.from(json["data"].map((x) => PrimaryTag.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class PrimaryTag {
  PrimaryTag({
    required this.primaryId,
    required this.primaryName,
    required this.secondaryTag,
  });

  int primaryId;
  String primaryName;
  List<SecondaryTag> secondaryTag;

  factory PrimaryTag.fromJson(String str) => PrimaryTag.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrimaryTag.fromMap(Map<String, dynamic> json) => PrimaryTag(
        primaryId: json["primary_id"] ?? 0,
        primaryName: json["primary_name"] ?? "",
        secondaryTag:
            json["secondary_tag"] == null ? [] : List<SecondaryTag>.from(json["secondary_tag"].map((x) => SecondaryTag.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "primary_id": primaryId,
        "primary_name": primaryName,
        "secondary_tag": secondaryTag == null ? null : List<dynamic>.from(secondaryTag.map((x) => x.toMap())),
      };

  @override
  String toString() {
    return 'PrimaryTag{primaryId: $primaryId, primaryName: $primaryName, secondaryTag: $secondaryTag}';
  }
}

class SecondaryTag {
  SecondaryTag({
    required this.id,
    required this.name,
  });

  int id;
  String name;
  bool check = false;

  factory SecondaryTag.fromJson(String str) => SecondaryTag.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SecondaryTag.fromMap(Map<String, dynamic> json) => SecondaryTag(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };

  @override
  String toString() {
    return 'SecondaryTag{id: $id, name: $name, check: $check}';
  }
}
