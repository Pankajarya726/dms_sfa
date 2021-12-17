// To parse this JSON data, do
//
//     final quotesAndImagesResponse = quotesAndImagesResponseFromMap(jsonString);

import 'dart:convert';

class QuotesAndImagesResponse {
  QuotesAndImagesResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  Data? data;

  factory QuotesAndImagesResponse.fromJson(String str) =>
      QuotesAndImagesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuotesAndImagesResponse.fromMap(Map<String, dynamic> json) =>
      QuotesAndImagesResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class Data {
  Data({
    required this.id,
    required this.image,
    required this.text,
  });

  int id;
  String image;
  String text;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        text: json["text"] == null ? null : json["text"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "text": text == null ? null : text,
      };
}
