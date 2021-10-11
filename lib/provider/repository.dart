import 'package:dio/dio.dart';
import 'package:sfa/main.dart';
import 'package:sfa/provider/url.dart';
import 'package:sfa/ui/login_screen/login_model/login_response.dart';

class ApiRepository {
  static final ApiRepository repository = ApiRepository.internal();

  factory ApiRepository() {
    return repository;
  }

  ApiRepository.internal();

  Future<LoginResponse> login(Map input) async {
    try {
      Response response = await dio.post(
        Url.login,
        data: input,
      );
      if (response.statusCode == 200) {
        LoginResponse res = LoginResponse.fromJson(response.toString());
        return res;
      } else {
        return LoginResponse(
            success: false,
            message: "Please try again later",
            id: 0,
            accessToken: "",
            tokenType: "");
      }
    } catch (exception) {
      return LoginResponse(
          success: false,
          message: "Please try again later",
          id: 0,
          accessToken: "",
          tokenType: "");
    }
  }
}
