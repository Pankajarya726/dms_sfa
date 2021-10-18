import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sfa/main.dart';
import 'package:sfa/provider/url.dart';
import 'package:sfa/ui/absent/bloc/model/mark_absent_by_user.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';
import 'package:sfa/ui/login_screen/login_model/login_response.dart';

class ApiRepository {
  static final ApiRepository repository = ApiRepository.internal();

  factory ApiRepository() {
    return repository;
  }

  ApiRepository.internal();

  Future<MarkAbsentByUserResponse> markAbsentByUser(
      userId, absentDate, absentReason) async {
    Map<String, dynamic> data = {
      "user_id": userId,
      "absent_date": absentDate,
      "absent_reason": absentReason,
    };

    try {
      Response response = await dio.post(
        Url.markAbsentByUser,
        data: data,
      );
      log(data.toString());
      if (response.statusCode == 200) {
        MarkAbsentByUserResponse markAbsentByUserResponse =
            MarkAbsentByUserResponse.fromJson(response.toString());
        return markAbsentByUserResponse;
      } else {
        return MarkAbsentByUserResponse(
            success: false, message: "Something went wrong");
      }
    } catch (exception) {
      return MarkAbsentByUserResponse(
        success: false,
        message: "Something went wrong",
      );
    }
  }

  Future<LoginResponse> login(String mobileNumber, String password) async {
    Map<String, dynamic> data = {
      "mobile_number": mobileNumber,
      "password": password
    };

    try {
      Response response = await dio.post(
        Url.login,
        data: data,
      );
      if (response.statusCode == 200) {
        LoginResponse loginDetails =
            LoginResponse.fromJson(response.toString());
        return loginDetails;
      } else {
        return LoginResponse(
            success: false,
            message: "Invalid Login details",
            id: 0,
            accessToken: "",
            tokenType: "");
      }
    } catch (exception) {
      return LoginResponse(
          success: false,
          message: "Something went wrong!",
          id: 0,
          accessToken: "",
          tokenType: "");
    }
  }

  Future<UserData> getUserDetailsByUserId(String id) async {
    Map<String, dynamic> userId = {"id": id};

    try {
      Response response = await dio.post(
        Url.getUserDetailsByUserId,
        data: userId,
      );

      if (response.statusCode == 200) {
        UserData userData = UserData.fromJson(response.toString());
        return userData;
      } else {
        return UserData(
            success: false,
            message: "Data not found",
            id: 0,
            name: "",
            email: "",
            mobileNumber: "",
            image: "",
            designation: "");
      }
    } catch (exception) {
      return UserData(
          success: false,
          message: "Something went wrong!",
          id: 0,
          name: "",
          email: "",
          mobileNumber: "",
          image: "",
          designation: "");
    }
  }
}
