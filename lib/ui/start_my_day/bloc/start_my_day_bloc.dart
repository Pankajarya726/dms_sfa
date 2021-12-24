import 'package:dms/ui/start_my_day/bloc/start_my_day_events.dart';
import 'package:dms/ui/start_my_day/bloc/start_my_day_states.dart';
import 'package:dms/ui/start_my_day/model/end_my_day_response.dart';
import 'package:dms/ui/start_my_day/model/quotes_and_images_response.dart';
import 'package:dms/ui/start_my_day/model/start_my_day_response.dart.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

import '../../../main.dart';

class StartMyDayBloc extends Bloc<StartMyDayEvents, StartMyDayStates> {
  StartMyDayBloc() : super(StartMyDayInitialState());

  @override
  Stream<StartMyDayStates> mapEventToState(StartMyDayEvents event) async* {
    if (event is GetQuotesAndImagesEvent) {
      yield* getQuotesAndImages(event);
    }
    if (event is StartMyDayEvent) {
      yield StartMyDayLoadingState();
      yield* startMyDay(event);
    }
    if (event is EndMyDayEvent) {
      yield StartMyDayLoadingState();
      yield* endMyDay(event);
    }
  }

  Stream<StartMyDayStates> getQuotesAndImages(
      GetQuotesAndImagesEvent event) async* {
    if (await Network.isConnected()) {
      DateTime _ntpTime;
      _ntpTime = await NTP.now();

      QuotesAndImagesResponse response = await repository.getQuotesAndImages();

      if (response.success) {
        yield GetQuotesAndImagesState(
            quotesAndImagesResponse: response,
            currentDate: DateFormat("yyyy-MM-dd").format(_ntpTime));
      } else {
        yield StartMyDayFailureState(failureMessage: response.message);
      }
    } else {
      yield StartMyDayFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }

  Stream<StartMyDayStates> startMyDay(StartMyDayEvent event) async* {
    if (await Network.isConnected()) {
      EasyLoading.show();
      StartMyDayResponse response = await repository.startMyDayApi(event.input);
      EasyLoading.dismiss();
      if (response.success) {
        yield StartMyDaySuccessState(successMessage: response.message);
      } else {
        yield StartMyDayFailureState(failureMessage: response.message);
      }
    } else {
      yield StartMyDayFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }

  Stream<StartMyDayStates> endMyDay(EndMyDayEvent event) async* {
    if (await Network.isConnected()) {
      String userId =
          await SharedPreference.getStringPreference(SharedPreference.userId);
      DateTime _ntpTime;
      _ntpTime = await NTP.now();
      String webtime = "${_ntpTime.hour}:${_ntpTime.minute}:${_ntpTime.second}";
      EasyLoading.show();
      EndMyDayResponse response = await repository.endMyDay(
        userId,
        DateFormat("yyyy-MM-dd").format(_ntpTime),
        webtime,
      );
      EasyLoading.dismiss();
      if (response.success) {
        yield EndMyDaySuccessState(endMyDayResponse: response);
      } else {
        yield EndMyDayFailureState(failureMessage: response.message);
      }
    } else {
      yield EndMyDayFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }
}
