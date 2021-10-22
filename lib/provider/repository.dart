import 'package:dio/dio.dart';
import 'package:sfa/main.dart';
import 'package:sfa/provider/url.dart';
import 'package:sfa/ui/absent/bloc/model/mark_absent_by_user.dart';
import 'package:sfa/ui/add_pjp_screen/add_pjp_model/add_pjp_model.dart';
import 'package:sfa/ui/attendence_clock_in_out/model/clock_in_response.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';
import 'package:sfa/ui/login_screen/login_model/login_response.dart';
import 'package:sfa/ui/team_members_absent/model/get_absent_data_response.dart';

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

  Future<ClockInResponse> clockIn(
    String id,
    String inOutTime,
    String inOutDate,
    String workingPlan,
    String selfieImage,
    String latitude,
    String longitude,
  ) async {
    Map<String, dynamic> data = {
      "id": id,
      "in_out_time": inOutTime,
      "in_out_date": inOutDate,
      "working_plan": workingPlan,
      "salf_image": selfieImage,
      "latitude": latitude,
      "longitude": longitude,
    };
    try {
      Response response = await dio.post(Url.clockIn, data: data);

      if (response.statusCode == 200) {
        ClockInResponse clockInResponse =
            ClockInResponse.fromJson(response.toString());
        return clockInResponse;
      } else {
        return ClockInResponse(
          success: false,
          message: "Something went wrong!",
        );
      }
    } catch (exception) {
      return ClockInResponse(
        success: false,
        message: "Something went wrong!",
      );
    }
  }

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

  Future<GetAbsentDataResponse> getAbsentData(userId, absentDate) async {
    Map<String, dynamic> data = {
      "user_id": userId,
      "date_added": absentDate,
    };

    try {
      Response response = await dio.post(
        Url.getAbsentData,
        data: data,
      );
      if (response.statusCode == 200) {
        GetAbsentDataResponse getAbsentDataResponse =
            GetAbsentDataResponse.fromJson(response.toString());
        return getAbsentDataResponse;
      } else {
        return GetAbsentDataResponse(
            success: false, message: "Something went wrong");
      }
    } catch (exception) {
      return GetAbsentDataResponse(
        success: false,
        message: "Something went wrong",
      );
    }
  }

  Future<AddPjpResponse> addPjp(
      String id, String date, String description) async {
    Map<String, dynamic> pjpData = {
      "user_id": id,
      "pjp_date": date,
      "pjp_description": description
    };

    try {
      Response response = await dio.post(
        Url.addPjp,
        data: pjpData,
      );

      if (response.statusCode == 200) {
        AddPjpResponse result = AddPjpResponse.fromJson(response.toString());
        return result;
      } else {
        return AddPjpResponse(
            message: response.statusMessage.toString(), success: false);
      }
    } catch (exception) {
      return AddPjpResponse(message: "Something went Wrong!", success: false);
    }
  }
}
