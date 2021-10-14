// To parse this JSON data, do
//
//     final userData = userDataFromMap(jsonString);

import 'dart:convert';

class UserData {
  UserData({
    required this.success,
    required this.message,
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.image,
    required this.designation,
  });

  bool success;
  String message;
  int id;
  String name;
  String email;
  String mobileNumber;
  String image;
  String designation;

  factory UserData.fromJson(String str) => UserData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
        success: json["success"],
        message: json["message"],
        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        image: json["image"],
        designation: json["designation"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "id": id,
        "name": name,
        "email": email,
        "mobile_number": mobileNumber,
        "image": image,
        "designation": designation,
      };
}
