// To parse this JSON data, do
//
//     final updateProfileResponse = updateProfileResponseFromMap(jsonString);

import 'dart:convert';

class UpdateProfileResponse {
  UpdateProfileResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  User? data;

  factory UpdateProfileResponse.fromJson(String str) => UpdateProfileResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpdateProfileResponse.fromMap(Map<String, dynamic> json) => UpdateProfileResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? null : User.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.mobileNumber,
  });

  int id;
  String name;
  String email;
  String profilePicture;
  String mobileNumber;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        profilePicture: json["profile_picture"] == null ? null : json["profile_picture"],
        mobileNumber: json["mobile_number"] == null ? null : json["mobile_number"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "profile_picture": profilePicture == null ? null : profilePicture,
        "mobile_number": mobileNumber == null ? null : mobileNumber,
      };
}
