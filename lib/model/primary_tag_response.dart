// // To parse this JSON data, do
// //
// //     final primaryTagResponse = primaryTagResponseFromMap(jsonString);
//
// import 'dart:convert';
//
// class PrimaryTagResponse {
//   PrimaryTagResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });
//
//   bool success;
//   String message;
//   List<PrimaryTag> data;
//
//   factory PrimaryTagResponse.fromJson(String str) => PrimaryTagResponse.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory PrimaryTagResponse.fromMap(Map<String, dynamic> json) => PrimaryTagResponse(
//         success: json["success"] == null ? false : json["success"],
//         message: json["message"] == null ? "" : json["message"],
//         data: json["data"] == null ? [] : List<PrimaryTag>.from(json["data"].map((x) => PrimaryTag.fromMap(x))),
//       );
//
//   Map<String, dynamic> toMap() => {
//         "success": success == null ? null : success,
//         "message": message == null ? null : message,
//         "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toMap())),
//       };
// }
//
// class PrimaryTag {
//   PrimaryTag({
//     required this.id,
//     required this.name,
//   });
//
//   String id;
//   String name;
//
//   factory PrimaryTag.fromJson(String str) => PrimaryTag.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory PrimaryTag.fromMap(Map<String, dynamic> json) => PrimaryTag(
//         id: json["id"] == null ? "0" : json["id"].toString(),
//         name: json["name"] == null ? "" : json["name"].toString(),
//       );
//
//   Map<String, dynamic> toMap() => {
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//       };
//
//   @override
//   String toString() {
//     return 'PrimaryTag{id: $id, name: $name}';
//   }
// }
