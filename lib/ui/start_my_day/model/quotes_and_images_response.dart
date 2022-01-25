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

  factory QuotesAndImagesResponse.fromJson(String str) => QuotesAndImagesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuotesAndImagesResponse.fromMap(Map<String, dynamic> json) => QuotesAndImagesResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
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
        id: json["id"],
        image: json["image"],
        text: json["text"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "image": image,
        "text": text,
      };
}
