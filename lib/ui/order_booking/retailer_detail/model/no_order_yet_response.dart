import 'dart:convert';

class NoOrderYetResponse {
  NoOrderYetResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<NoOrderYetModal>? data;

  factory NoOrderYetResponse.fromJson(String str) =>
      NoOrderYetResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NoOrderYetResponse.fromMap(Map<String, dynamic> json) =>
      NoOrderYetResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<NoOrderYetModal>.from(
                json["data"].map((x) => NoOrderYetModal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class NoOrderYetModal {
  NoOrderYetModal({
    required this.id,
    required this.name,
    required this.image,
  });

  String id;
  String name;
  String image;

  factory NoOrderYetModal.fromJson(String str) =>
      NoOrderYetModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NoOrderYetModal.fromMap(Map<String, dynamic> json) => NoOrderYetModal(
        id: json["id"] == null ? "" : json["id"].toString(),
        name: json["name"] == null ? "" : json["name"].toString(),
        image: json["image"] == null ? "" : json["image"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "image": image,
      };
}
