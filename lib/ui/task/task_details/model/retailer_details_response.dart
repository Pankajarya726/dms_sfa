import 'dart:convert';

class GetPendingTaskResponse {
  GetPendingTaskResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<PendingTaskModal>? data;

  factory GetPendingTaskResponse.fromJson(String str) => GetPendingTaskResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetPendingTaskResponse.fromMap(Map<String, dynamic> json) => GetPendingTaskResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? [] : List<PendingTaskModal>.from(json["data"].map((x) => PendingTaskModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class PendingTaskModal {
  PendingTaskModal({
    required this.id,
    required this.taskCode,
    required this.taskDate,
    required this.taskType,
    required this.escalationRemark,
    required this.taskRemark,
    required this.action,
    required this.escalationTo,
    required this.escalationTag,
    required this.buId,
  });

  String id;
  String taskCode;
  String taskDate;
  String taskType;
  String escalationRemark;
  String taskRemark;
  String action;
  List<EscalationTo> escalationTo;
  List<EscalationTag> escalationTag;
  List<BuId> buId;

  factory PendingTaskModal.fromJson(String str) => PendingTaskModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PendingTaskModal.fromMap(Map<String, dynamic> json) => PendingTaskModal(
        id: json["id"] == null ? "" : json["id"].toString(),
        taskCode: json["task_code"] == null ? "" : json["task_code"].toString(),
        taskDate: json["task_date"] == null ? "" : json["task_date"].toString(),
        taskType: json["task_type"] == null ? "" : json["task_type"].toString(),
        action: json["action"] == null ? "0" : json["action"].toString(),
        escalationRemark: json["escalation_remark"] == null ? "" : json["escalation_remark"].toString(),
        taskRemark: json["task_remark"] == null ? "" : json["task_remark"].toString(),
        escalationTo:
            json["escalation_to"] == null ? [] : List<EscalationTo>.from(json["escalation_to"].map((x) => EscalationTo.fromMap(x))),
        escalationTag: json["escalation_tag"] == null
            ? []
            : List<EscalationTag>.from(json["escalation_tag"].map((x) => EscalationTag.fromMap(x))),
        buId: json["bu_id"] == null ? [] : List<BuId>.from(json["bu_id"].map((x) => BuId.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "task_code": taskCode,
        "task_date": taskDate,
        "task_type": taskType,
        "escalation_remark": escalationRemark,
        "task_remark": taskRemark,
        "action": action,
        "escalation_to": escalationTo == null ? [] : List<dynamic>.from(escalationTo.map((x) => x.toMap())),
        "escalation_tag": escalationTag == null ? [] : List<dynamic>.from(escalationTag.map((x) => x.toMap())),
        "bu_id": buId == null ? [] : List<dynamic>.from(buId.map((x) => x.toMap())),
      };
}

class BuId {
  BuId({
    required this.id,
    required this.buName,
  });

  String id;
  String buName;

  factory BuId.fromJson(String str) => BuId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BuId.fromMap(Map<String, dynamic> json) => BuId(
        id: json["id"] == null ? "" : json["id"].toString(),
        buName: json["bu_name"] == null ? "" : json["bu_name"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "bu_name": buName,
      };
}

class EscalationTag {
  EscalationTag({
    required this.id,
    required this.tagName,
  });

  String id;
  String tagName;

  factory EscalationTag.fromJson(String str) => EscalationTag.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EscalationTag.fromMap(Map<String, dynamic> json) => EscalationTag(
        id: json["id"] == null ? "" : json["id"].toString(),
        tagName: json["tag_name"] == null ? "" : json["tag_name"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "tag_name": tagName,
      };
}

class EscalationTo {
  EscalationTo({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory EscalationTo.fromJson(String str) => EscalationTo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EscalationTo.fromMap(Map<String, dynamic> json) => EscalationTo(
        id: json["id"] == null ? "" : json["id"].toString(),
        name: json["name"] == null ? "" : json["name"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}

// import 'dart:convert';

// class GetPendingTaskResponse {
//   GetPendingTaskResponse({
//     required this.success,
//     required this.message,
//     this.data,
//   });

//   bool success;
//   String message;
//   List<PendingTaskModal>? data;

//   factory GetPendingTaskResponse.fromJson(String str) =>
//       GetPendingTaskResponse.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory GetPendingTaskResponse.fromMap(Map<String, dynamic> json) =>
//       GetPendingTaskResponse(
//         success: json["success"] ?? false,
//         message: json["message"] ?? "",
//         data: json["data"] == null
//             ? []
//             : List<PendingTaskModal>.from(
//                 json["data"].map((x) => PendingTaskModal.fromMap(x))),
//       );

//   Map<String, dynamic> toMap() => {
//         "success": success,
//         "message": message,
//         "data":
//             data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
//       };
// }

// class PendingTaskModal {
//   PendingTaskModal({
//     required this.id,
//     required this.taskCode,
//     required this.taskDate,
//     required this.taskType,
//     required this.escalationTag,
//     required this.escalationRemark,
//     required this.taskRemark,
//     required this.elapseDays,
//     required this.escalationTo,
//     required this.buId,
//   });

//   String id;
//   String taskCode;
//   String taskDate;
//   String taskType;
//   String escalationTag;
//   String escalationRemark;
//   String taskRemark;
//   String elapseDays;
//   List<EscalationTo> escalationTo;
//   List<BuId> buId;

//   factory PendingTaskModal.fromJson(String str) =>
//       PendingTaskModal.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory PendingTaskModal.fromMap(Map<String, dynamic> json) =>
//       PendingTaskModal(
//         id: json["id"] == null ? "" : json["id"].toString(),
//         taskCode: json["task_code"] == null ? "" : json["task_code"].toString(),
//         taskDate: json["task_date"] == null ? "" : json["task_date"].toString(),
//         taskType: json["task_type"] == null ? "" : json["task_type"].toString(),
//         escalationTag: json["escalation_tag"] == null
//             ? ""
//             : json["escalation_tag"].toString(),
//         escalationRemark: json["escalation_remark"] == null
//             ? ""
//             : json["escalation_remark"].toString(),
//         taskRemark:
//             json["task_remark"] == null ? "" : json["task_remark"].toString(),
//         elapseDays:
//             json["elapse_days"] == null ? "" : json["elapse_days"].toString(),
//         escalationTo: json["escalation_to"] == null
//             ? []
//             : List<EscalationTo>.from(
//                 json["escalation_to"].map((x) => EscalationTo.fromMap(x))),
//         buId: json["bu_id"] == null
//             ? []
//             : List<BuId>.from(json["bu_id"].map((x) => BuId.fromMap(x))),
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "task_code": taskCode,
//         "task_date": taskDate,
//         "task_type": taskType,
//         "escalation_tag": escalationTag,
//         "escalation_remark": escalationRemark,
//         "task_remark": taskRemark,
//         "elapse_days": elapseDays,
//         "escalation_to": escalationTo == null
//             ? []
//             : List<dynamic>.from(escalationTo.map((x) => x.toMap())),
//         "bu_id":
//             buId == null ? [] : List<dynamic>.from(buId.map((x) => x.toMap())),
//       };
// }

// class BuId {
//   BuId({
//     required this.id,
//     required this.buName,
//   });

//   String id;
//   String buName;

//   factory BuId.fromJson(String str) => BuId.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory BuId.fromMap(Map<String, dynamic> json) => BuId(
//         id: json["id"] == null ? "" : json["id"].toString(),
//         buName: json["bu_name"] == null ? "" : json["bu_name"].toString(),
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "bu_name": buName,
//       };
// }

// class EscalationTo {
//   EscalationTo({
//     required this.id,
//     required this.name,
//   });

//   String id;
//   String name;

//   factory EscalationTo.fromJson(String str) =>
//       EscalationTo.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory EscalationTo.fromMap(Map<String, dynamic> json) => EscalationTo(
//         id: json["id"] == null ? "" : json["id"].toString(),
//         name: json["name"] == null ? "" : json["name"].toString(),
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "name": name,
//       };
// }
