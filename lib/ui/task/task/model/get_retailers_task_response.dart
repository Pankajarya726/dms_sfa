import 'dart:convert';

class GetRetailersTaskResponse {
  GetRetailersTaskResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<RetailersTaskModal>? data;

  factory GetRetailersTaskResponse.fromJson(String str) =>
      GetRetailersTaskResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetRetailersTaskResponse.fromMap(Map<String, dynamic> json) =>
      GetRetailersTaskResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<RetailersTaskModal>.from(
                json["data"].map((x) => RetailersTaskModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class RetailersTaskModal {
  RetailersTaskModal({
    required this.retailerId,
    required this.uniqueCode,
    required this.outletName,
    required this.primaryMobile,
    required this.primaryAddress,
    required this.enrollmentDate,
    required this.taskType,
    required this.enrollmentTypeId,
    required this.enrollmentTypeName,
    required this.latitude,
    required this.longitude,
    required this.beatId,
    required this.beatName,
    required this.lastOrder,
    required this.outletPicture,
    required this.pendingTask,
    required this.taskHistory,
    this.totalMonths = "",
    required this.taskWiseData,
    required this.lastEscalation,
  });

  String retailerId;
  String uniqueCode;
  String outletName;
  String primaryMobile;
  String primaryAddress;
  String enrollmentDate;
  String taskType;
  String enrollmentTypeId;
  String enrollmentTypeName;
  String latitude;
  String longitude;
  String beatId;
  String beatName;
  String lastOrder;
  String outletPicture;
  String pendingTask;
  String taskHistory;
  String totalMonths;
  List<TaskWiseRetailersTaskModal> taskWiseData;
  List<LastEscalation> lastEscalation;

  factory RetailersTaskModal.fromJson(String str) =>
      RetailersTaskModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RetailersTaskModal.fromMap(Map<String, dynamic> json) =>
      RetailersTaskModal(
        retailerId:
            json["retailer_id"] == null ? "" : json["retailer_id"].toString(),
        uniqueCode:
            json["unique_code"] == null ? "" : json["unique_code"].toString(),
        outletName:
            json["outlet_name"] == null ? "" : json["outlet_name"].toString(),
        primaryMobile: json["primary_mobile"] == null
            ? ""
            : json["primary_mobile"].toString(),
        primaryAddress: json["primary_address"] == null
            ? ""
            : json["primary_address"].toString(),
        enrollmentDate: json["enrollment_date"] == null
            ? ""
            : json["enrollment_date"].toString(),
        taskType: json["task_type"] == null ? "" : json["task_type"].toString(),
        enrollmentTypeId: json["enrollment_type_id"] == null
            ? ""
            : json["enrollment_type_id"].toString(),
        enrollmentTypeName: json["enrollment_type_name"] == null
            ? ""
            : json["enrollment_type_name"].toString(),
        latitude: json["latitude"] == null ? "" : json["latitude"].toString(),
        longitude:
            json["longitude"] == null ? "" : json["longitude"].toString(),
        beatId: json["beat_id"] == null ? "" : json["beat_id"].toString(),
        beatName: json["beat_name"] == null ? "" : json["beat_name"].toString(),
        lastOrder:
            json["last_order"] == null ? "" : json["last_order"].toString(),
        outletPicture: json["outlet_picture"] == null
            ? ""
            : json["outlet_picture"].toString(),
        pendingTask:
            json["pending_task"] == null ? "" : json["pending_task"].toString(),
        taskHistory:
            json["task_history"] == null ? "" : json["task_history"].toString(),
        taskWiseData: json["task_wise_data"] == null
            ? []
            : List<TaskWiseRetailersTaskModal>.from(json["task_wise_data"]
                .map((x) => TaskWiseRetailersTaskModal.fromMap(x))),
        lastEscalation: json["last_escalation"] == null
            ? []
            : List<LastEscalation>.from(
                json["last_escalation"].map((x) => LastEscalation.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "retailer_id": retailerId,
        "unique_code": uniqueCode,
        "outlet_name": outletName,
        "primary_mobile": primaryMobile,
        "primary_address": primaryAddress,
        "enrollment_date": enrollmentDate,
        "task_type": taskType,
        "enrollment_type_id": enrollmentTypeId,
        "enrollment_type_name": enrollmentTypeName,
        "latitude": latitude,
        "longitude": longitude,
        "beat_id": beatId,
        "beat_name": beatName,
        "last_order": lastOrder,
        "outlet_picture": outletPicture,
        "pending_task": pendingTask,
        "task_history": taskHistory,
        "task_wise_data": taskWiseData == null
            ? []
            : List<dynamic>.from(taskWiseData.map((x) => x.toMap())),
        "last_escalation": lastEscalation == null
            ? []
            : List<dynamic>.from(lastEscalation.map((x) => x.toMap())),
      };
}

class LastEscalation {
  LastEscalation({
    required this.reassignDate,
    required this.escalationTag,
    required this.taskRemark,
    required this.reassignRemark,
    required this.bus,
  });

  String reassignDate;
  String escalationTag;
  String taskRemark;
  String reassignRemark;
  List<Bus> bus;

  factory LastEscalation.fromJson(String str) =>
      LastEscalation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LastEscalation.fromMap(Map<String, dynamic> json) => LastEscalation(
        reassignDate: json["reassign_date"] == null
            ? ""
            : json["reassign_date"].toString(),
        escalationTag: json["escalation_tag"] == null
            ? ""
            : json["escalation_tag"].toString(),
        taskRemark:
            json["task_remark"] == null ? "" : json["task_remark"].toString(),
        reassignRemark: json["reassign_remark"] == null
            ? ""
            : json["reassign_remark"].toString(),
        bus: json["bus"] == null
            ? []
            : List<Bus>.from(json["bus"].map((x) => Bus.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "reassign_date": reassignDate,
        "escalation_tag": escalationTag,
        "task_remark": taskRemark,
        "reassign_remark": reassignRemark,
        "bus": bus == null ? [] : List<dynamic>.from(bus.map((x) => x.toMap())),
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

class TaskWiseRetailersTaskModal {
  TaskWiseRetailersTaskModal({
    required this.taskNumber,
    required this.escalationTag,
    required this.taskType,
  });

  String taskNumber;
  String escalationTag;
  String taskType;

  factory TaskWiseRetailersTaskModal.fromJson(String str) =>
      TaskWiseRetailersTaskModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaskWiseRetailersTaskModal.fromMap(Map<String, dynamic> json) =>
      TaskWiseRetailersTaskModal(
        taskNumber:
            json["task_number"] == null ? "" : json["task_number"].toString(),
        escalationTag: json["escalation_tag"] == null
            ? ""
            : json["escalation_tag"].toString(),
        taskType: json["task_type"] == null ? "" : json["task_type"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "task_number": taskNumber,
        "escalation_tag": escalationTag,
        "task_type": taskType,
      };
}
