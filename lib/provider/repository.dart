import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dms/main.dart';
import 'package:dms/provider/url.dart';
import 'package:dms/ui/change_password/model/model.dart';
import 'package:dms/ui/drawer_menu/home_screen/model/home_screen_model.dart';
import 'package:dms/ui/edit_profile/model/edit_profile_model.dart';
import 'package:dms/ui/login_screen/login_model/login_response.dart';
import 'package:dms/ui/splash_screen/model/splash_model.dart';

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
            message: response.statusMessage.toString(),
            id: 0,
            accessToken: "",
            tokenType: "",
            isLeader: false);
      }
    } catch (exception) {
      return LoginResponse(
          success: false,
          message: "Something went wrong!",
          id: 0,
          accessToken: "",
          tokenType: "",
          isLeader: false);
    }
  }

  Future<EditProfileResponse> editProfile(
      String name, String email, File? imgFile) async {
    Map<String, dynamic> params = HashMap<String, dynamic>();

    params["name"] = name;
    params["email"] = email;

    if (imgFile != null) {
      params["profile_picture"] = await MultipartFile.fromFile(imgFile.path,
          filename: DateTime.now().millisecondsSinceEpoch.toString() + ".jpg");
    }

    FormData data = FormData.fromMap(params);
    try {
      Response response = await dio.post(
        Url.editProfile,
        data: data,
      );

      if (response.statusCode == 200) {
        EditProfileResponse result =
            EditProfileResponse.fromJson(response.toString());
        return result;
      } else {
        return EditProfileResponse(
          message: response.statusMessage.toString(),
          success: false,
        );
      }
    } catch (exception) {
      return EditProfileResponse(
        message: "Something went Wrong!",
        success: false,
      );
    }
  }

  Future<UserDetails> getUserDetailsByUserId(String id) async {
    Map<String, dynamic> userId = {"id": id};

    try {
      Response response = await dio.post(
        Url.getUserDetailsByUserId,
        data: userId,
      );

      if (response.statusCode == 200) {
        UserDetails userData = UserDetails.fromJson(response.toString());
        return userData;
      } else {
        return UserDetails(
            success: false,
            message: response.statusMessage.toString(),
            data: null);
      }
    } catch (exception) {
      return UserDetails(
          success: false, message: "Something went wrong!", data: null);
    }
  }

  Future<ChangePassResponse> changePassword(String id, String currPassword,
      String newPassword, String confPassword) async {
    Map<String, dynamic> params = {
      "current_password": currPassword,
      "new_password": newPassword,
      "password_confirmation": confPassword,
      "id": id
    };

    try {
      Response response = await dio.post(
        Url.changePassword,
        data: params,
      );

      if (response.statusCode == 200) {
        ChangePassResponse result =
            ChangePassResponse.fromJson(response.toString());
        return result;
      } else {
        return ChangePassResponse(
          message: response.statusMessage.toString(),
          success: false,
        );
      }
    } catch (exception) {
      return ChangePassResponse(
        message: "Something went Wrong!",
        success: false,
      );
    }
  }

  Future<SplashResponse> validateAppVersion(
      String version, String deviceType) async {
    Map<String, dynamic> params = {
      "app_version": version,
      "device_type": deviceType,
    };

    try {
      Response response = await dio.post(
        Url.validateAppVer,
        data: params,
      );

      if (response.statusCode == 200) {
        SplashResponse result = SplashResponse.fromJson(response.toString());
        return result;
      } else {
        return SplashResponse(
          message: response.statusMessage.toString(),
          success: false,
          data: null,
        );
      }
    } catch (exception) {
      return SplashResponse(
        message: "Something went Wrong!",
        success: false,
        data: null,
      );
    }
  }
}
