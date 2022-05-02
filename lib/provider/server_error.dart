import 'package:dio/dio.dart';
import 'package:dms/ui/login_screen/login_screen.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ServerError implements Exception {
  int? _errorCode = 200;
  String _errorMessage = "";

  ServerError.withError({required DioError? error}) {
    _handleError(error!);
  }

  getErrorCode() {
    return _errorCode;
  }

  getErrorMessage() {
    return _errorMessage;
  }

  _handleError(DioError error) async {
    _errorCode = error.response!.statusCode!;
    debugPrint(error.toString());
    debugPrint("_errorCode-->$_errorCode");
    debugPrint(error.message);
    switch (error.type) {
      case DioErrorType.cancel:
        _errorMessage = "Request was cancelled";
        break;
      case DioErrorType.connectTimeout:
        _errorMessage = "Connection timeout";
        break;
      case DioErrorType.other:
        _errorMessage = "Connection failed due to internet connection";
        break;
      case DioErrorType.receiveTimeout:
        _errorMessage = "Receive timeout in connection";
        break;
      case DioErrorType.response:
        _errorMessage = "Internal server error";
        if (error.response!.statusCode == 401) {
          _errorMessage = "";

          logout();
        }
        if (error.response!.statusCode == 500) {
          Utility.showToast("Internal server error");
        }

        break;

      case DioErrorType.sendTimeout:
        _errorMessage = "Receive timeout in send request";
        break;
    }
    return _errorMessage;
  }

  void logout() async {
    showDialog(
        context: navigationService.navigatorKey.currentContext!,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (context) => WillPopScope(
            child: AlertDialog(
              content: const Text(
                  "Your session has been expired! Please login again."),
              contentPadding: const EdgeInsets.all(15),
              actions: [
                TextButton(
                    onPressed: () async {
                      await SharedPreference.clearSharedPreference(context);

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          ModalRoute.withName("/"));
                    },
                    child: const Text("Ok"))
              ],
            ),
            onWillPop: () async {
              return false;
            }));

    // EasyLoading.showError("Your session has been expired! Please login again",);
  }
}
