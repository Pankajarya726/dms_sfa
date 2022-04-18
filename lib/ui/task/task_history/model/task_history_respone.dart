import 'dart:convert';

class TaskHistoryResponse {
  TaskHistoryResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<TaskHistoryModal>? data;

  factory TaskHistoryResponse.fromJson(String str) =>
      TaskHistoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaskHistoryResponse.fromMap(Map<String, dynamic> json) =>
      TaskHistoryResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<TaskHistoryModal>.from(
                json["data"].map((x) => TaskHistoryModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class TaskHistoryModal {
  TaskHistoryModal({
    required this.id,
    required this.taskUniuqeId,
    required this.taskDate,
    required this.taskType,
    required this.escalationTag,
    required this.resolveDate,
    required this.isResolve,
  });

  String id;
  String taskUniuqeId;
  String taskDate;
  String taskType;
  String escalationTag;
  String resolveDate;
  String isResolve;

  factory TaskHistoryModal.fromJson(String str) =>
      TaskHistoryModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaskHistoryModal.fromMap(Map<String, dynamic> json) =>
      TaskHistoryModal(
        id: json["id"] == null ? "" : json["id"].toString(),
        taskUniuqeId: json["task_uniuqe_id"] == null
            ? ""
            : json["task_uniuqe_id"].toString(),
        taskDate: json["task_date"] == null ? "" : json["task_date"].toString(),
        taskType: json["task_type"] == null ? "" : json["task_type"].toString(),
        escalationTag: json["escalation_tag"] == null
            ? ""
            : json["escalation_tag"].toString(),
        resolveDate:
            json["resolve_date"] == null ? "" : json["resolve_date"].toString(),
        isResolve:
            json["is_resolve"] == null ? "" : json["is_resolve"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "task_uniuqe_id": taskUniuqeId,
        "task_date": taskDate,
        "task_type": taskType,
        "escalation_tag": escalationTag,
        "resolve_date": resolveDate,
        "is_resolve": isResolve,
      };
}
