import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dms/main.dart';
import 'package:dms/model/get_plan_response.dart';
import 'package:dms/model/primary_tag_response.dart';
import 'package:dms/model/secondary_tag_response.dart';
import 'package:dms/provider/url.dart';
import 'package:dms/ui/add_plan/model/AddPlanResponse.dart';
import 'package:dms/ui/add_plan/model/AddPlanUpdateData.dart';
import 'package:dms/ui/change_password/model/model.dart';
import 'package:dms/ui/drawer_menu/home_screen/model/get_menus_response.dart';
import 'package:dms/ui/drawer_menu/home_screen/model/user_details_response.dart';
import 'package:dms/ui/edit_profile/model/edit_profile_model.dart';
import 'package:dms/ui/login_screen/login_model/login_response.dart';
import 'package:dms/ui/splash_screen/model/splash_model.dart';
import 'package:dms/ui/start_my_day/model/end_my_day_response.dart';
import 'package:dms/ui/start_my_day/model/quotes_and_images_response.dart';
import 'package:dms/ui/start_my_day/model/start_my_day_response.dart.dart';

class ApiRepository {
  static final ApiRepository repository = ApiRepository.internal();

  factory ApiRepository() {
    return repository;
  }

  ApiRepository.internal();

  Future<SplashResponse> validateAppVersion(Map input) async {
    try {
      Response response = await dio.post(
        Url.validateAppVer,
        data: input,
      );

      if (response.statusCode == 200) {
        SplashResponse result = SplashResponse.fromJson(response.toString());
        return result;
      } else {
        return SplashResponse(
          message: response.statusMessage.toString(),
          success: false,
        );
      }
    } catch (exception) {
      return SplashResponse(
        message: "Something went Wrong!",
        success: false,
      );
    }
  }

  Future<LoginResponse> login(String mobileNumber, String password) async {
    Map<String, dynamic> data = {"mobile_number": mobileNumber, "password": password};

    try {
      Response response = await dio.post(
        Url.login,
        data: data,
      );
      if (response.statusCode == 200) {
        LoginResponse loginDetails = LoginResponse.fromJson(response.toString());
        return loginDetails;
      } else {
        return LoginResponse(
            success: false,
            message: response.statusMessage.toString(),
            id: 0,
            accessToken: "",
            tokenType: "",
            isLeader: false,
            startMyDay: "");
      }
    } catch (exception) {
      return LoginResponse(
          success: false, message: "Something went wrong!", id: 0, accessToken: "", tokenType: "", isLeader: false, startMyDay: "");
    }
  }

  Future<QuotesAndImagesResponse> getQuotesAndImages() async {
    try {
      Response response = await dio.get(Url.getQuotesAndImages);

      if (response.statusCode == 200) {
        QuotesAndImagesResponse quotesAndImagesResponse = QuotesAndImagesResponse.fromJson(response.toString());
        return quotesAndImagesResponse;
      } else {
        return QuotesAndImagesResponse(
          success: false,
          message: response.statusMessage.toString(),
        );
      }
    } catch (exception) {
      return QuotesAndImagesResponse(
        success: false,
        message: "Something went wrong!",
      );
    }
  }

  Future<StartMyDayResponse> startMyDayApi(Map<String, dynamic> input) async {
    FormData formData = FormData.fromMap(input);

    try {
      Response response = await dio.post(Url.startMyDay, data: formData);

      if (response.statusCode == 200) {
        StartMyDayResponse startMyDayResponse = StartMyDayResponse.fromJson(response.toString());
        return startMyDayResponse;
      } else {
        return StartMyDayResponse(
          success: false,
          message: response.statusMessage.toString(),
        );
      }
    } catch (exception) {
      return StartMyDayResponse(
        success: false,
        message: "Something went wrong!",
      );
    }
  }

  Future<GetMenusResponse> getMenus() async {
    try {
      Response response = await dio.get(
        Url.getMenus,
      );

      if (response.statusCode == 200) {
        GetMenusResponse result = GetMenusResponse.fromJson(response.toString());
        return result;
      } else {
        return GetMenusResponse(
          message: response.statusMessage.toString(),
          success: false,
          data: [],
        );
      }
    } catch (exception) {
      return GetMenusResponse(
        message: "Something went Wrong!",
        success: false,
        data: [],
      );
    }
  }

  Future<EndMyDayResponse> endMyDay(
    String userId,
    String endDayDate,
    String endDayTime,
  ) async {
    Map<String, dynamic> data = {
      "user_id": userId,
      "start_day_date": endDayDate,
      "end_day_time": endDayTime,
    };

    try {
      Response response = await dio.post(Url.endMyDay, data: data);
      if (response.statusCode == 200) {
        EndMyDayResponse endMyDayResponse = EndMyDayResponse.fromJson(response.toString());
        return endMyDayResponse;
      } else {
        return EndMyDayResponse(
          success: false,
          message: response.statusMessage.toString(),
        );
      }
    } catch (exception) {
      return EndMyDayResponse(
        success: false,
        message: "Something went wrong!",
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
        return UserDetails(success: false, message: response.statusMessage.toString(), data: null);
      }
    } catch (exception) {
      return UserDetails(success: false, message: "Something went wrong!", data: null);
    }
  }

  Future<EditProfileResponse> editProfile(String name, String email, File? imgFile) async {
    Map<String, dynamic> params = HashMap<String, dynamic>();

    params["name"] = name;
    params["email"] = email;

    if (imgFile != null) {
      params["profile_picture"] =
          await MultipartFile.fromFile(imgFile.path, filename: DateTime.now().millisecondsSinceEpoch.toString() + ".jpg");
    }

    FormData data = FormData.fromMap(params);
    try {
      Response response = await dio.post(
        Url.editProfile,
        data: data,
      );

      if (response.statusCode == 200) {
        EditProfileResponse result = EditProfileResponse.fromJson(response.toString());
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

  Future<ChangePassResponse> changePassword(String id, String currPassword, String newPassword, String confPassword) async {
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
        ChangePassResponse result = ChangePassResponse.fromJson(response.toString());
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

  Future<AddPlanResponse> addPlan(Map input) async {
    try {
      Response response = await dio.post(
        Url.addPlan,
        data: input,
      );
      if (response.statusCode == 200) {
        AddPlanResponse addPlanResponse = AddPlanResponse.fromJson(response.toString());
        return addPlanResponse;
      } else {
        return AddPlanResponse(
          success: false,
          message: response.statusMessage.toString(),
        );
      }
    } catch (exception) {
      return AddPlanResponse(
        success: false,
        message: "Something went wrong!",
      );
    }
  }

  Future<PrimaryTagResponse> getPrimaryTag() async {
    try {
      Response response = await dio.get(
        Url.getPrimaryTag,
      );
      return PrimaryTagResponse.fromJson(response.toString());
    } catch (exception) {
      return PrimaryTagResponse(
        success: false,
        message: "Something went wrong!",
        data: [],
      );
    }
  }

  Future<SecondaryTagResponse> getSecondaryTag(String primaryTag) async {
    // try {
    Map input = {"Primary_tag": primaryTag};
    Response response = await dio.post(Url.getSecondaryTag, data: input);
    return SecondaryTagResponse.fromJson(response.toString());
    // } catch (exception) {
    //   debugPrint("exception---->$exception");
    //   return SecondaryTagResponse(
    //     success: false,
    //     message: "Something went wrong!",
    //   );
    // }
  }

  Future<GetPlanResponse> getSavedPlan(Map input) async {
    try {
      Response response = await dio.post(
        Url.getSavedPlan,
        data: input,
      );

      return GetPlanResponse.fromJson(response.toString());
    } catch (exception) {
      return GetPlanResponse(
        success: false,
        message: "Something went wrong!",
        data: [],
      );
    }
  }

  Future<GetPlanResponse> getPlanByMonth(
    String userId,
    String addPlanDate,
  ) async {
    Map<String, dynamic> data = {
      "user_id": userId,
      "month": addPlanDate,
    };

    // try {
    Response response = await dio.post(
      Url.getMyPlanByMonth,
      data: data,
    );
    GetPlanResponse getAddPlanDataResponse = GetPlanResponse.fromJson(response.toString());
    return getAddPlanDataResponse;
    // } catch (exception) {
    //   return GetPlanResponse(
    //     success: false,
    //     message: "Something went wrong!",
    //     data: [],
    //   );
    // }
  }

  Future<AddPlanUpdateDataResponse> addPlanUpdateData(Map input) async {
    try {
      Response response = await dio.post(
        Url.updateAddPlan,
        data: input,
      );
      if (response.statusCode == 200) {
        AddPlanUpdateDataResponse getAddPlanDataResponse = AddPlanUpdateDataResponse.fromJson(response.toString());
        return getAddPlanDataResponse;
      } else {
        return AddPlanUpdateDataResponse(
          success: false,
          message: response.statusMessage.toString(),
        );
      }
    } catch (exception) {
      return AddPlanUpdateDataResponse(
        success: false,
        message: "Something went wrong!",
      );
    }
  }
}
