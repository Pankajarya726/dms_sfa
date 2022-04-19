import 'dart:convert';

class TaskResponse {
  TaskResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<Task> data;

  factory TaskResponse.fromJson(String str) => TaskResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaskResponse.fromMap(Map<String, dynamic> json) => TaskResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? [] : List<Task>.from(json["data"].map((x) => Task.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toMap())),
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
  int taskId;
  int id;
  String escalationTag;
  String taskRemark;
  DateTime taskDate;
  List<Bus> bus;
  bool check = false;

  factory Task.fromJson(String str) => Task.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        outletCode: json["outlet_code"] == null ? "" : json["outlet_code"].toString(),
        outletName: json["outlet_name"] == null ? "" : json["outlet_name"].toString(),
        taskId: json["task_id"] ?? 0,
        id: json["id"] ?? 0,
        escalationTag: json["escalation_tag"] == null ? "" : json["escalation_tag"].toString(),
        taskRemark: json["task_remark"] == null ? "" : json["task_remark"].toString(),
        taskDate: json["task_date"] == null ? DateTime.now() : DateTime.parse(json["task_date"]),
        bus: json["bus"] == null ? [] : List<Bus>.from(json["bus"].map((x) => Bus.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "outlet_code": outletCode,
        "outlet_name": outletName,
        "task_id": taskId,
        "id": id,
        "escalation_tag": escalationTag,
        "task_remark": taskRemark,
        "task_date": taskDate == null
            ? null
            : "${taskDate.year.toString().padLeft(4, '0')}-${taskDate.month.toString().padLeft(2, '0')}-${taskDate.day.toString().padLeft(2, '0')}",
        "bus": bus == null ? null : List<dynamic>.from(bus.map((x) => x.toMap())),
      };
}

class Bus {
  Bus({
    required this.id,
    required this.buName,
  });

  int id;
  String buName;

  factory Bus.fromJson(String str) => Bus.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Bus.fromMap(Map<String, dynamic> json) => Bus(
        id: json["id"] == null ? null : json["id"],
        buName: json["bu_name"] == null ? null : json["bu_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "bu_name": buName == null ? null : buName,
      };
}
