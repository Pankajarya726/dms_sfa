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
        "data": data,
      };
}

class PrimaryTag {
  PrimaryTag({
    required this.id,
    required this.selected,
    required this.canSelect,
    required this.secondaryTagType,
    required this.selectionType,
    required this.name,
    required this.secondaryTag,
  });

  int id;
  int selected;
  int canSelect;
  String secondaryTagType;
  String selectionType;
  String name;
  List<SecondaryTag> secondaryTag;

  factory PrimaryTag.fromJson(String str) => PrimaryTag.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrimaryTag.fromMap(Map<String, dynamic> json) => PrimaryTag(
        id: json["id"] ?? 0,
        selected: json["selected"] ?? 0,
        canSelect: json["can_select"] ?? 0,
        secondaryTagType: json["secondary_tag_ui_type"] ?? "",
        selectionType: json["selection_type"] ?? "",
        name: json["name"] ?? "",
        secondaryTag:
            json["secondary_tag"] == null ? [] : List<SecondaryTag>.from(json["secondary_tag"].map((x) => SecondaryTag.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "primary_id": id,
        "selected": selected,
        "can_select": canSelect,
        "secondary_tag_ui_type": secondaryTagType,
        "selection_type": selectionType,
        "name": name,
        "secondary_tag": secondaryTag,
      };

  @override
  String toString() {
    return 'PrimaryTag{id: $id, selected: $selected, canSelect: $canSelect, secondaryTagType: $secondaryTagType, selectionType: $selectionType, name: $name, secondaryTag: $secondaryTag}';
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
