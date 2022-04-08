import 'dart:convert';

class GetReasonsResponse {
  GetReasonsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<ReasonsModal> data;

  factory GetReasonsResponse.fromJson(String str) => GetReasonsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetReasonsResponse.fromMap(Map<String, dynamic> json) => GetReasonsResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? [] : List<ReasonsModal>.from(json["data"].map((x) => ReasonsModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class ReasonsModal {
  ReasonsModal({
    required this.id,
    required this.tagName,
    required this.taskType,
  });

  String id;
  String tagName;
  String taskType;

  factory ReasonsModal.fromJson(String str) => ReasonsModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReasonsModal.fromMap(Map<String, dynamic> json) => ReasonsModal(
        id: json["id"] == null ? "" : json["id"].toString(),
        tagName: json["tag_name"] == null ? "" : json["tag_name"].toString(),
        taskType: json["task_type"] == null ? "" : json["task_type"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "tag_name": tagName,
        "task_type": taskType,
      };
}
