import 'dart:convert';

class DetailsStatusResponse {
  DetailsStatusResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  DetailsResponse? data;

  factory DetailsStatusResponse.fromJson(String str) =>
      DetailsStatusResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetailsStatusResponse.fromMap(Map<String, dynamic> json) =>
      DetailsStatusResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data:
            json["data"] == null ? null : DetailsResponse.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class DetailsResponse {
  DetailsResponse({
    required this.inTime,
    required this.inDate,
    required this.inWorkingPlan,
    required this.pjpDescription,
    required this.inImage,
    required this.outTime,
    required this.outDate,
    required this.comments,
    required this.outImage,
  });

  String inTime;
  DateTime? inDate;
  String inWorkingPlan;
  String pjpDescription;
  String inImage;
  String outTime;
  DateTime? outDate;
  String comments;
  String outImage;

  factory DetailsResponse.fromJson(String str) =>
      DetailsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetailsResponse.fromMap(Map<String, dynamic> json) => DetailsResponse(
        inTime: json["in_time"] == null ? null : json["in_time"],
        inDate:
            json["in_date"] == null ? null : DateTime.parse(json["in_date"]),
        inWorkingPlan:
            json["in_working_plan"] == null ? null : json["in_working_plan"],
        pjpDescription:
            json["pjp_description"] == null ? null : json["pjp_description"],
        inImage: json["in_image"] == null ? null : json["in_image"],
        outTime: json["out_time"] == null ? null : json["out_time"],
        outDate:
            json["out_date"] == null ? null : DateTime.parse(json["out_date"]),
        comments: json["comments"] == null ? null : json["comments"],
        outImage: json["out_image"] == null ? null : json["out_image"],
      );

  Map<String, dynamic> toMap() => {
        "in_time": inTime == null ? null : inTime,
        "in_date": inDate == null
            ? null
            : "${inDate!.year.toString().padLeft(4, '0')}-${inDate!.month.toString().padLeft(2, '0')}-${inDate!.day.toString().padLeft(2, '0')}",
        "in_working_plan": inWorkingPlan == null ? null : inWorkingPlan,
        "pjp_description": pjpDescription == null ? null : pjpDescription,
        "in_image": inImage == null ? null : inImage,
        "out_time": outTime == null ? null : outTime,
        "out_date": outDate == null
            ? null
            : "${outDate!.year.toString().padLeft(4, '0')}-${outDate!.month.toString().padLeft(2, '0')}-${outDate!.day.toString().padLeft(2, '0')}",
        "comments": comments == null ? null : comments,
        "out_image": outImage == null ? null : outImage,
      };
}
