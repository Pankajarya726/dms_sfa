import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dms/main.dart';
import 'package:dms/model/base_response.dart';
import 'package:dms/model/get_all_tag_response.dart';
import 'package:dms/model/get_plan_response.dart';
import 'package:dms/model/get_survey_product.dart';
import 'package:dms/model/retaileres_response.dart';
import 'package:dms/provider/server_error.dart';
import 'package:dms/provider/url.dart';
import 'package:dms/ui/add_plan/model/add_plan_response.dart';
import 'package:dms/ui/add_plan/model/add_plan_update_data.dart';
import 'package:dms/ui/add_store/model/call_time_slot_response.dart';
import 'package:dms/ui/add_store/model/editstore_getenroll_type_response.dart';
import 'package:dms/ui/add_store/model/orderbooking_day_response.dart';
import 'package:dms/ui/add_store/model/select_beat_response.dart';
import 'package:dms/ui/add_store/model/select_distributor_response.dart';
import 'package:dms/ui/add_store/model/select_district_response.dart';
import 'package:dms/ui/add_store/model/select_language_response.dart';
import 'package:dms/ui/add_store/model/select_retailer_category_response.dart';
import 'package:dms/ui/add_store/model/select_retailer_type_response.dart';
import 'package:dms/ui/change_password/model/model.dart';
import 'package:dms/ui/drawer_menu/home_screen/model/get_menus_response.dart';
import 'package:dms/ui/drawer_menu/home_screen/model/user_details_response.dart';
import 'package:dms/ui/edit_profile/model/update_profile_response.dart';
import 'package:dms/ui/login_screen/login_model/login_response.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_brand_&_category_resonse.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_schemes_response.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/retailer_details_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/ui/splash_screen/model/splash_model.dart';
import 'package:dms/ui/start_my_day/model/end_my_day_response.dart';
import 'package:dms/ui/start_my_day/model/quotes_and_images_response.dart';
import 'package:dms/ui/start_my_day/model/start_my_day_response.dart.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class ApiRepository {
  static final ApiRepository repository = ApiRepository.internal();

  factory ApiRepository() {
    return repository;
  }

  ApiRepository.internal();

  Future<SplashResponse> validateAppVersion(Map input) async {
    try {
      Response response = await dio.post(Url.validateAppVer,
          data: input,
          options: buildCacheOptions(const Duration(days: 7),
              forceRefresh: true, maxStale: const Duration(days: 7)));
      SplashResponse result = SplashResponse.fromJson(response.toString());
      return result;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return SplashResponse(success: false, message: message);
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
      LoginResponse loginDetails = LoginResponse.fromJson(response.toString());
      return loginDetails;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return LoginResponse(success: false, message: message);
    }
  }

  Future<QuotesAndImagesResponse> getQuotesAndImages() async {
    try {
      Response response = await dio.get(Url.getQuotesAndImages);

      QuotesAndImagesResponse quotesAndImagesResponse =
          QuotesAndImagesResponse.fromJson(response.toString());
      return quotesAndImagesResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return QuotesAndImagesResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<StartMyDayResponse> startMyDayApi(Map<String, dynamic> input) async {
    debugPrint("input-->$input");
    FormData formData = FormData.fromMap(input);

    try {
      Response response = await dio.post(Url.startMyDay, data: formData);

      StartMyDayResponse startMyDayResponse =
          StartMyDayResponse.fromJson(response.toString());
      return startMyDayResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return StartMyDayResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<GetMenusResponse> getMenus() async {
    try {
      Response response = await dio.get(
        Url.getMenus,
        options: buildCacheOptions(
          const Duration(days: 3),
          maxStale: const Duration(days: 7),
        ),
      );
      if (null != response.headers.value(DIO_CACHE_HEADER_KEY_DATA_SOURCE)) {
        debugPrint("data come from cache");
      } else {
        debugPrint("data come from net");
      }
      GetMenusResponse result = GetMenusResponse.fromJson(response.toString());
      return result;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return GetMenusResponse(
        message: message,
        success: false,
        data: [],
      );
    }
  }

  Future<EndMyDayResponse> endMyDay(
    String userId,
    String endDayDate,
    String endDayTime,
    String endDayAddress,
  ) async {
    Map<String, dynamic> data = {
      "user_id": userId,
      "start_day_date": endDayDate,
      "end_day_time": endDayTime,
      "end_day_address": endDayAddress,
    };

    try {
      Response response = await dio.post(Url.endMyDay, data: data);

      EndMyDayResponse endMyDayResponse =
          EndMyDayResponse.fromJson(response.toString());
      return endMyDayResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return EndMyDayResponse(success: false, message: message, status: "0");
    }
  }

  Future<GetUserResponse> getUserDetailsByUserId(String id) async {
    Map<String, dynamic> userId = {"id": id};

    try {
      Response response = await dio.post(
        Url.getUserDetailsByUserId,
        data: userId,
      );

      GetUserResponse userData = GetUserResponse.fromJson(response.toString());
      return userData;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return GetUserResponse(success: false, message: message, data: null);
    }
  }

  Future<UpdateProfileResponse> editProfile(
      String name, String email, File? imgFile) async {
    Map<String, dynamic> params = HashMap<String, dynamic>();

    params["user_id"] =
        await SharedPreference.getStringPreference(SharedPreference.userId);
    params["name"] = name;
    params["email"] = email;

    if (imgFile != null) {
      params["profile_picture"] = await MultipartFile.fromFile(imgFile.path,
          filename: DateTime.now().millisecondsSinceEpoch.toString() + ".jpg");
    }
    debugPrint("params-->$params");

    FormData data = FormData.fromMap(params);
    try {
      Response response = await dio.post(
        Url.editProfile,
        data: data,
      );

      UpdateProfileResponse result =
          UpdateProfileResponse.fromJson(response.toString());
      return result;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return UpdateProfileResponse(
        message: message,
        success: false,
      );
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

      ChangePassResponse result =
          ChangePassResponse.fromJson(response.toString());
      return result;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return ChangePassResponse(
        message: message,
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

      AddPlanResponse addPlanResponse =
          AddPlanResponse.fromJson(response.toString());
      return addPlanResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return AddPlanResponse(
        success: false,
        message: message,
      );
    }
  }

  // Future<PrimaryTagResponse> getPrimaryTag() async {
  //   try {
  //     Response response = await dio.get(
  //       Url.getPrimaryTag,
  //     );
  //     return PrimaryTagResponse.fromJson(response.toString());
  //   } catch (error, stacktrace) {
  //     String message = "";
  //     if (error is DioError) {
  //       ServerError e = ServerError.withError(error: error);
  //       message = e.getErrorMessage();
  //     } else {
  //       message = "Something Went wrong";
  //     }
  //     debugPrint("Exception occurred: $message stackTrace: $stacktrace");
  //     return PrimaryTagResponse(
  //       success: false,
  //       message: message,
  //       data: [],
  //     );
  //   }
  // }
  //
  // Future<SecondaryTagResponse> getSecondaryTag(String primaryTag) async {
  //   try {
  //     Map input = {"Primary_tag": primaryTag};
  //     Response response = await dio.post(Url.getSecondaryTag, data: input);
  //     return SecondaryTagResponse.fromJson(response.toString());
  //   } catch (error, stacktrace) {
  //     String message = "";
  //     if (error is DioError) {
  //       ServerError e = ServerError.withError(error: error);
  //       message = e.getErrorMessage();
  //     } else {
  //       message = "Something Went wrong";
  //     }
  //     debugPrint("Exception occurred: $message stackTrace: $stacktrace");
  //     return SecondaryTagResponse(
  //       success: false,
  //       message: message,
  //     );
  //   }
  // }

  Future<GetPlanByDateResponse> getSavedPlan(Map input) async {
    try {
      Response response = await dio.post(
        Url.getSavedPlan,
        data: input,
      );

      return GetPlanByDateResponse.fromJson(response.toString());
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return GetPlanByDateResponse(
        success: false,
        message: message,
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

    try {
      Response response = await dio.post(
        Url.getMyPlanByMonth,
        data: data,
      );
      GetPlanResponse getAddPlanDataResponse =
          GetPlanResponse.fromJson(response.toString());
      return getAddPlanDataResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return GetPlanResponse(
        success: false,
        message: message,
        data: [],
      );
    }
  }

  Future<AddPlanUpdateDataResponse> addPlanUpdateData(Map input) async {
    try {
      Response response = await dio.post(
        Url.updateAddPlan,
        data: input,
      );

      AddPlanUpdateDataResponse getAddPlanDataResponse =
          AddPlanUpdateDataResponse.fromJson(response.toString());
      return getAddPlanDataResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return AddPlanUpdateDataResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<BaseResponse> confirmEndDay(Map input) async {
    try {
      Response response = await dio.post(
        Url.confirmEndDAy,
        data: input,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return BaseResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<GetAllTagResponse> getAllTags() async {
    try {
      Map input = {
        "user_id": await Utility.getStringPreference(SharedPreference.userId)
      };
      Response response = await dio.post(
        Url.getAllTags,
        data: input,
      );

      GetAllTagResponse baseResponse =
          GetAllTagResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return GetAllTagResponse(
        success: false,
        message: message,
        data: [],
      );
    }
  }

  Future<GetEnrollTypeResponse> getEnrolmentType() async {
    try {
      Response response = await dio.get(Url.getEnrollmentType);
      GetEnrollTypeResponse baseResponse =
          GetEnrollTypeResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something went wrong!";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return GetEnrollTypeResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<SelectLanguageResponse> selectLanguage() async {
    try {
      Response response = await dio.get(Url.getLanguage);
      SelectLanguageResponse baseResponse =
          SelectLanguageResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something went wrong!";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return SelectLanguageResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<SelectRetailerTypeResponse> selectRetailerType() async {
    try {
      Response response = await dio.get(Url.getRetailerType);
      SelectRetailerTypeResponse baseResponse =
          SelectRetailerTypeResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something went wrong!";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return SelectRetailerTypeResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<SelectRetailerCategoryResponse> selectRetailerCategory() async {
    try {
      Response response = await dio.get(Url.getRetailerCategory);
      SelectRetailerCategoryResponse baseResponse =
          SelectRetailerCategoryResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something went wrong!";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return SelectRetailerCategoryResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<SelectDistrictResponse> selectDistrict() async {
    try {
      Response response = await dio.post(Url.getDistrict);
      SelectDistrictResponse baseResponse =
          SelectDistrictResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something went wrong!";
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return SelectDistrictResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<SelectDistributorResponse> selectDistributor(Map input) async {
    try {
      Response response = await dio.post(
        Url.getDistributor,
        data: input,
      );
      SelectDistributorResponse baseResponse =
          SelectDistributorResponse.fromJson(response.toString());

      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return SelectDistributorResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<CallTimeSlotResponse> selectCallTimeslot() async {
    try {
      Response response = await dio.get(Url.getCallTimeSlot);
      CallTimeSlotResponse baseResponse =
          CallTimeSlotResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return CallTimeSlotResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<GetSurveyProduct> getSurveyProduct() async {
    try {
      Response response = await dio.get(Url.getRetailerProducts);
      GetSurveyProduct getSurveyProduct =
          GetSurveyProduct.fromJson(response.toString());
      return getSurveyProduct;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return GetSurveyProduct(
        success: false,
        message: message,
        data: [],
      );
    }
  }

  Future<SelectBeatResponse> selectBeat(Map input) async {
    try {
      Response response = await dio.post(Url.getDistributorsBeat, data: input);
      SelectBeatResponse baseResponse =
          SelectBeatResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return SelectBeatResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<BaseResponse> registerRetailer(Map<String, dynamic> input) async {
    try {
      FormData data = FormData.fromMap(input);
      Response response =
          await dio.post(Url.retailerEnrollmentSave, data: data);
      BaseResponse baseResponse = BaseResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return BaseResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<BaseResponse> verifyOtp(Map<String, dynamic> input) async {
    try {
      Response response = await dio.post(Url.verifyOtp, data: input);
      BaseResponse baseResponse = BaseResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return BaseResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<OrderBookingDayResponse> orderBookingDay(Map input) async {
    try {
      Response response = await dio.post(Url.getOrderBookingDay, data: input);
      OrderBookingDayResponse baseResponse =
          OrderBookingDayResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return OrderBookingDayResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<RetailersResponse> searchRetailer(Map input) async {
    try {
      Response response = await dio.post(Url.searchRetailer, data: input);
      RetailersResponse baseResponse =
          RetailersResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return RetailersResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<GetBrandCategoryResponse> getBrandAndCategory(Map input) async {
    try {
      Response response = await dio.post(Url.getBrandAndCategory, data: input);
      GetBrandCategoryResponse baseResponse =
          GetBrandCategoryResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return GetBrandCategoryResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<GetAllBeatsResponse> getAllBeats() async {
    try {
      Response response = await dio.get(Url.getAllBeats);
      GetAllBeatsResponse baseResponse =
          GetAllBeatsResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return GetAllBeatsResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<GetAllBeatsResponse> getBeatByOrderBookingDay() async {
    try {
      DateTime dateTime =
          await NTP.now().timeout(const Duration(seconds: 15), onTimeout: () {
        return DateTime.now();
      });
      Map<String, dynamic> input = {"day": DateFormat("EEEE").format(dateTime)};

      Response response =
          await dio.post(Url.getBeatByOrderBookingDay, data: input);
      GetAllBeatsResponse baseResponse =
          GetAllBeatsResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return GetAllBeatsResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<GetRetailersResponse> getRetailersOrderWise(Map input) async {
    try {
      Response response = await dio.post(Url.getRetailerOrderWise, data: input);
      GetRetailersResponse baseResponse =
          GetRetailersResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return GetRetailersResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<RetailersDetailsResponse> getRetailerInfo(Map input) async {
    try {
      Response response = await dio.post(Url.getRetailerInfo, data: input);
      RetailersDetailsResponse baseResponse =
          RetailersDetailsResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return RetailersDetailsResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<GetProductsResponse> getProducts(Map input) async {
    try {
      Response response = await dio.post(Url.getProducts, data: input);
      GetProductsResponse baseResponse =
          GetProductsResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return GetProductsResponse(
        success: false,
        message: message,
      );
    }
  }

  Future<GetSchemesResponse> getSchemeProducts(Map input) async {
    try {
      Response response = await dio.post(Url.getSchemeProducts, data: input);
      GetSchemesResponse baseResponse =
          GetSchemesResponse.fromJson(response.toString());
      return baseResponse;
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = StringConst.somethingWR;
      }
      debugPrint("Exception occurred: $message stackTrace: $stacktrace");
      return GetSchemesResponse(
        success: false,
        message: message,
      );
    }
  }
}
