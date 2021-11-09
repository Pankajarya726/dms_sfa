import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sfa/main.dart';
import 'package:sfa/provider/url.dart';
import 'package:sfa/ui/absent/bloc/model/mark_absent_by_user.dart';
import 'package:sfa/ui/add_pjp_screen/add_pjp_model/add_pjp_model.dart';
import 'package:sfa/ui/attendence_clock_in_out/model/clock_in_response.dart';
import 'package:sfa/ui/attendence_clock_in_out/model/clock_out_response.dart';
import 'package:sfa/ui/change_password/model/model.dart';
import 'package:sfa/ui/edit_profile/model/edit_profile_model.dart';
import 'package:sfa/ui/forgot_password/model/forgot_password_model.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';
import 'package:sfa/ui/home_screen/home_screen_model/menu_model.dart';
import 'package:sfa/ui/login_screen/login_model/login_response.dart';
import 'package:sfa/ui/pjp_screen/pjp_model/pjp_model.dart';
import 'package:sfa/ui/pjp_screen/update_pjp_model/update_pjp_model.dart';
import 'package:sfa/ui/splash_screen/model/splash_model.dart';
import 'package:sfa/ui/team%20members_status/model/get_all_users_status.dart';
import 'package:sfa/ui/team_member_attendence/model/attendance_model.dart';
import 'package:sfa/ui/team_member_track_screen/model/track_model.dart';
import 'package:sfa/ui/team_members_absent/model/absent_approve_reject_response.dart';
import 'package:sfa/ui/team_members_absent/model/get_absent_data_response.dart';
import 'package:sfa/ui/team_members_clockout/model/clockin_approve_reject_model.dart';
import 'package:sfa/ui/team_members_clockout/model/get_clock_in_data_response.dart';
import 'package:sfa/ui/team_members_details_screen/model/team_members_details_model.dart';

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

//clock in repository
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
      "user_id": id,
      "clock_in_time": inOutTime,
      "in_out_date": inOutDate,
      "working_plan": workingPlan,
      "clock_in_image": await MultipartFile.fromFile(selfieImage.path,
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

//clock out repository
  Future<ClockOutResponse> clockOut(
    String id,
    String inOutTime,
    String inOutDate,
    String workingPlan,
    File selfieImage,
  ) async {
    Map<String, dynamic> data = {
      "user_id": id,
      "clock_out_time": inOutTime,
      "in_out_date": inOutDate,
      "comment": workingPlan,
      "clock_out_image": await MultipartFile.fromFile(selfieImage.path,
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

  Future<GetAllUsersStatusResponse> getAllUsersStatus(
      userId, statusDate) async {
    Map<String, dynamic> data = {
      "user_id": userId,
      "status_date": statusDate,
    };

    try {
      Response response = await dio.post(
        Url.getAllUsersStatus,
        data: data,
      );
      if (response.statusCode == 200) {
        GetAllUsersStatusResponse getClockInDataResponse =
            GetAllUsersStatusResponse.fromJson(response.toString());
        return getClockInDataResponse;
      } else {
        return GetAllUsersStatusResponse(
          success: false,
          message: "Something went wrong!",
        );
      }
    } catch (exception) {
      return GetAllUsersStatusResponse(
        success: false,
        message: "Something went wrong!",
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

// get all absent data repository
  Future<GetAbsentDataResponse> getAbsentData(userId, absentDate) async {
    Map<String, dynamic> data = {
      "user_id": userId,
      "date_added": absentDate,
    };

    print("absent data = $data");
    try {
      Response response = await dio.post(
        Url.getAbsentData,
        data: FormData.fromMap(data),
      );

      if (response.statusCode == 200) {
        GetAbsentDataResponse getAbsentDataResponse =
            GetAbsentDataResponse.fromJson(response.toString());
        return getAbsentDataResponse;
      } else {
        return GetAbsentDataResponse(
            success: false, message: "Something went wrong!");
      }
    } catch (exception) {
      return GetAbsentDataResponse(
        success: false,
        message: "Something went wrong!",
      );
    }
  }

// absent approve/reject repository
  Future<AbsentApproveRejectResponse> absentApproveReject(
      absentApprovedBy, userId, absentStatus, userAttendenceId) async {
    Map<String, dynamic> data = {
      "absent_approved_by": absentApprovedBy,
      "user_id": userId,
      "approved_status": absentStatus,
      "id": userAttendenceId,
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
      "approved_status": status,
      "approved_by": approvedBy
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

  Future<DetailsStatusResponse> getTeamMembersDetails(
      String id, String date) async {
    Map<String, dynamic> params = {
      "user_id": id,
      "status_date": date,
    };

    try {
      Response response = await dio.post(
        Url.teamMembersDetails,
        data: params,
      );

      if (response.statusCode == 200) {
        DetailsStatusResponse result =
            DetailsStatusResponse.fromJson(response.toString());

        return result;
      } else {
        return DetailsStatusResponse(
            message: response.statusMessage.toString(),
            success: false,
            data: null);
      }
    } catch (exception) {
      return DetailsStatusResponse(
          message: "Something went Wrong!", success: false, data: null);
    }
  }

  Future<AttendanceResponse> getTeamMembersAttendence(
      String id, String date) async {
    Map<String, dynamic> params = {
      "user_id": id,
      "att_date": date,
    };

    try {
      Response response = await dio.post(
        Url.teamMembersAttendence,
        data: params,
      );

      if (response.statusCode == 200) {
        AttendanceResponse result =
            AttendanceResponse.fromJson(response.toString());
        return result;
      } else {
        return AttendanceResponse(
            message: response.statusMessage.toString(),
            success: false,
            clockInData: []);
      }
    } catch (exception) {
      return AttendanceResponse(
          message: "Something went Wrong!", success: false, clockInData: []);
    }
  }

  Future<TrackResponse> getTrackData(String id, String date) async {
    Map<String, dynamic> params = {
      "user_id": id,
      "in_out_date": date,
    };

    try {
      Response response = await dio.post(
        Url.trackByUser,
        data: params,
      );

      if (response.statusCode == 200) {
        TrackResponse result = TrackResponse.fromJson(response.toString());
        return result;
      } else {
        return TrackResponse(
          message: response.statusMessage.toString(),
          success: false,
          data: [],
        );
      }
    } catch (exception) {
      return TrackResponse(
        message: "Something went Wrong!",
        success: false,
        data: [],
      );
    }
  }

  Future<HomeMenuResponse> getMenuData() async {
    try {
      Response response = await dio.get(
        Url.getMenu,
      );

      if (response.statusCode == 200) {
        HomeMenuResponse result =
            HomeMenuResponse.fromJson(response.toString());
        return result;
      } else {
        return HomeMenuResponse(
          message: response.statusMessage.toString(),
          success: false,
          data: [],
        );
      }
    } catch (exception) {
      return HomeMenuResponse(
        message: "Something went Wrong!",
        success: false,
        data: [],
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

  Future<ForgotPasswordResponse> forgotPassword(
      String mobileNo, String password, String confPassword) async {
    Map<String, dynamic> params = {
      "mobile_number": mobileNo,
      "password": password,
      "password_confirmation": confPassword,
    };

    try {
      Response response = await dio.post(
        Url.forgotPassword,
        data: params,
      );

      if (response.statusCode == 200) {
        ForgotPasswordResponse result =
            ForgotPasswordResponse.fromJson(response.toString());
        return result;
      } else {
        return ForgotPasswordResponse(
          message: response.statusMessage.toString(),
          success: false,
        );
      }
    } catch (exception) {
      return ForgotPasswordResponse(
        message: "Something went Wrong!",
        success: false,
      );
    }
  }
}
