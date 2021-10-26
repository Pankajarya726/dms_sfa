import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sfa/main.dart';
import 'package:sfa/provider/url.dart';
import 'package:sfa/ui/absent/bloc/model/mark_absent_by_user.dart';
import 'package:sfa/ui/add_pjp_screen/add_pjp_model/add_pjp_model.dart';
import 'package:sfa/ui/attendence_clock_in_out/model/clock_in_response.dart';
import 'package:sfa/ui/attendence_clock_in_out/model/clock_out_response.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';
import 'package:sfa/ui/login_screen/login_model/login_response.dart';
import 'package:sfa/ui/pjp_screen/pjp_model/pjp_model.dart';
import 'package:sfa/ui/pjp_screen/update_pjp_model/update_pjp_model.dart';
import 'package:sfa/ui/team_members_absent/model/absent_approve_reject_response.dart';
import 'package:sfa/ui/team_members_absent/model/get_absent_data_response.dart';
import 'package:sfa/ui/team_members_clockout/model/clockin_approve_reject_model.dart';
import 'package:sfa/ui/team_members_clockout/model/get_clock_in_data_response.dart';

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
            message: response.statusMessage.toString(),
            data: null);
      }
    } catch (exception) {
      return UserData(
          success: false, message: "Something went wrong!", data: null);
    }
  }

  Future<ClockInResponse> clockIn(
    String id,
    String inOutTime,
    String inOutDate,
    String workingPlan,
    File selfieImage,
    String latitude,
    String longitude,
  ) async {
    Map<String, dynamic> data = {
      "id": id,
      "in_out_time": inOutTime,
      "in_out_date": inOutDate,
      "working_plan": workingPlan,
      "salf_image": await MultipartFile.fromFile(selfieImage.path,
          filename: DateTime.now().millisecondsSinceEpoch.toString() + ".jpg"),
      "latitude": latitude,
      "longitude": longitude,
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response response = await dio.post(Url.clockIn, data: formData);

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

  Future<ClockOutResponse> clockOut(
    String id,
    String inOutTime,
    String inOutDate,
    String workingPlan,
    File selfieImage,
  ) async {
    Map<String, dynamic> data = {
      "user_id": id,
      "in_out_time": inOutTime,
      "in_out_date": inOutDate,
      "working_plan": workingPlan,
      "salf_image": await MultipartFile.fromFile(selfieImage.path,
          filename: DateTime.now().millisecondsSinceEpoch.toString() + ".jpg"),
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response response = await dio.post(Url.clockOut, data: formData);

      if (response.statusCode == 200) {
        ClockOutResponse clockOutResponse =
            ClockOutResponse.fromJson(response.toString());
        return clockOutResponse;
      } else {
        return ClockOutResponse(
          success: false,
          message: "Something went wrong!",
        );
      }
    } catch (exception) {
      return ClockOutResponse(
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

  Future<GetClockInDataResponse> getClockInData(userId, dateAdded) async {
    Map<String, dynamic> data = {
      "user_id": userId,
      "date_added": dateAdded,
    };

    try {
      Response response = await dio.post(
        Url.getClockInData,
        data: data,
      );
      if (response.statusCode == 200) {
        GetClockInDataResponse getClockInDataResponse =
            GetClockInDataResponse.fromJson(response.toString());
        return getClockInDataResponse;
      } else {
        return GetClockInDataResponse(
            success: false, message: "Something went wrong!", data: []);
      }
    } catch (exception) {
      return GetClockInDataResponse(
        success: false,
        message: "Something went wrong!",
        data: [],
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

  Future<AbsentApproveRejectResponse> absentApproveReject(
      absentApprovedBy, userId, absentStatus, userAttendenceId) async {
    Map<String, dynamic> data = {
      "absent_approved_by": absentApprovedBy,
      "user_id": userId,
      "absent_status": absentStatus,
      "user_attendence_id": userAttendenceId,
    };

    try {
      Response response = await dio.post(
        Url.absentApproveReject,
        data: data,
      );
      if (response.statusCode == 200) {
        AbsentApproveRejectResponse absentApproveRejectResponse =
            AbsentApproveRejectResponse.fromJson(response.toString());
        return absentApproveRejectResponse;
      } else {
        return AbsentApproveRejectResponse(
            success: false, message: "Something went wrong");
      }
    } catch (exception) {
      return AbsentApproveRejectResponse(
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

  Future<PjpResponse> getPjpData(String id, String month) async {
    Map<String, dynamic> params = {
      "user_id": id,
      "month": month,
    };

    try {
      Response response = await dio.post(
        Url.pjpGetCurrentMonthData,
        data: params,
      );

      if (response.statusCode == 200) {
        PjpResponse result = PjpResponse.fromJson(response.toString());

        return result;
      } else {
        return PjpResponse(
            message: response.statusMessage.toString(), success: false);
      }
    } catch (exception) {
      return PjpResponse(message: "Something went Wrong!", success: false);
    }
  }

  Future<UpdateResponce> updatePjpData(String id, String description) async {
    Map<String, dynamic> params = {
      "id": id,
      "pjp_description": description,
    };

    try {
      Response response = await dio.post(
        Url.updatePjp,
        data: params,
      );

      if (response.statusCode == 200) {
        UpdateResponce result = UpdateResponce.fromJson(response.toString());

        return result;
      } else {
        return UpdateResponce(
            message: response.statusMessage.toString(), success: false);
      }
    } catch (exception) {
      return UpdateResponce(message: "Something went Wrong!", success: false);
    }
  }

  Future<ClockInApproveRes> clockInApprovReject(
      String id, String status, String approvedBy) async {
    Map<String, dynamic> params = {
      "id": id,
      "clock_in_status": status,
      "clock_in_approved_by": approvedBy
    };

    try {
      Response response = await dio.post(
        Url.clockInApproveReject,
        data: params,
      );

      if (response.statusCode == 200) {
        ClockInApproveRes result =
            ClockInApproveRes.fromJson(response.toString());

        return result;
      } else {
        return ClockInApproveRes(
            message: response.statusMessage.toString(), success: false);
      }
    } catch (exception) {
      return ClockInApproveRes(
          message: "Something went Wrong!", success: false);
    }
  }
}
