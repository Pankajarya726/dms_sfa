import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sfa/main.dart';
import 'package:sfa/provider/url.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';
import 'package:sfa/ui/login_screen/login_model/login_response.dart';

class ApiRepository {
  static final ApiRepository repository = ApiRepository.internal();

  factory ApiRepository() {
    return repository;
  }

  ApiRepository.internal();

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
    log(userId.toString());

    try {
      Response response = await dio.post(
        Url.getUserDetailsByUserId,
        data: userId,
      );

      if (response.statusCode == 200) {
        UserData userDetails = UserData.fromJson(response.toString());
        return userDetails;
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
