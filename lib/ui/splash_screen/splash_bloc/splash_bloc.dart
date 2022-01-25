import 'dart:collection';
import 'dart:io';

import 'package:dms/ui/splash_screen/model/splash_model.dart';
import 'package:dms/ui/splash_screen/splash_bloc/splash_event.dart';
import 'package:dms/ui/splash_screen/splash_bloc/splash_state.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:package_info/package_info.dart';

import '../../../main.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitialState());
  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is ValidateAppEvent) {
      yield* validateAppVersion(event);
    }
  }

  Stream<SplashState> validateAppVersion(SplashEvent event) async* {
    if (await Network.isConnected()) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      Map<String, dynamic> input = HashMap<String, dynamic>();

      input["user_id"] = await SharedPreference.getStringPreference(SharedPreference.userId);
      input["date"] = DateFormat("yyyy-MM-dd").format(await NTP.now());
      // input["date"] = "2022-01-27";
      input["app_version"] = packageInfo.version;
      // input["app_version"] = "0.0";

      if (Platform.isAndroid) {
        input["device_type"] = 1;
      } else {
        input["device_type"] = 2;
      }

      checkForUpdate();

      SplashResponse response = await repository.validateAppVersion(input);

      if (response.success) {
        yield SplashSuccessState(response: response);
      } else {
        yield SplashFailureState(response: response);
      }
    } else {
      yield SplashNetworkState(message: "Network not connected");
    }
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      debugPrint("info--->${info.toString()}");
    }).catchError((e) {
      debugPrint("exception--->$e");
    });
  }

  updateFlexible() async {
    InAppUpdate.startFlexibleUpdate().then((_) {}).catchError((e) {
      debugPrint("updateFlexible--->");
      debugPrint("exception--->$e");
    });
  }

  updateImmediate() async {
    InAppUpdate.performImmediateUpdate().catchError((e) {
      debugPrint("updateFlexible--->");
      debugPrint("exception--->$e");
    });
  }
}
