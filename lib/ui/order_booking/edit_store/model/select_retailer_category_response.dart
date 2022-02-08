import 'dart:convert';

class SelectRetailerCategoryResponse {
  SelectRetailerCategoryResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<String>? data;

  factory SelectRetailerCategoryResponse.fromJson(String str) =>
      SelectRetailerCategoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectRetailerCategoryResponse.fromMap(Map<String, dynamic> json) =>
      SelectRetailerCategoryResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}
