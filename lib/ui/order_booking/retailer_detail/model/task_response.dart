import 'dart:convert';

class TaskResponse {
  TaskResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<Task>? data;

  factory TaskResponse.fromJson(String str) =>
      TaskResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaskResponse.fromMap(Map<String, dynamic> json) => TaskResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<Task>.from(json["data"].map((x) => Task.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Task {
  Task({
    required this.outletCode,
    required this.outletName,
    required this.id,
    required this.taskId,
    required this.escalationTag,
    required this.taskRemark,
    required this.taskDate,
    required this.bus,
  });

  String outletCode;
  String outletName;
  String taskId;
  String id;
  String escalationTag;
  String taskRemark;
  String taskDate;
  List<Bus> bus;
  bool check = false;

  factory Task.fromJson(String str) => Task.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        outletCode:
            json["outlet_code"] == null ? "" : json["outlet_code"].toString(),
        outletName:
            json["outlet_name"] == null ? "" : json["outlet_name"].toString(),
        taskId: json["task_id"] == null ? "" : json["task_id"].toString(),
        id: json["id"] == null ? "" : json["id"].toString(),
        escalationTag: json["escalation_tag"] == null
            ? ""
            : json["escalation_tag"].toString(),
        taskRemark:
            json["task_remark"] == null ? "" : json["task_remark"].toString(),
        taskDate: json["task_date"] == null ? "" : json["task_date"].toString(),
        bus: json["bus"] == null
            ? []
            : List<Bus>.from(json["bus"].map((x) => Bus.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "outlet_code": outletCode,
        "outlet_name": outletName,
        "task_id": taskId,
        "id": id,
        "escalation_tag": escalationTag,
        "task_remark": taskRemark,
        "task_date": taskDate,
        "bus":
            bus == null ? null : List<dynamic>.from(bus.map((x) => x.toMap())),
      };
}

class Bus {
  Bus({
    required this.id,
    required this.buName,
  });

  String id;
  String buName;

  factory Bus.fromJson(String str) => Bus.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Bus.fromMap(Map<String, dynamic> json) => Bus(
        id: json["id"] == null ? "" : json["id"].toString(),
        buName: json["bu_name"] == null ? "" : json["bu_name"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "bu_name": buName,
      };
}
