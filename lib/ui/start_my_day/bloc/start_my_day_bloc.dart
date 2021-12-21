import 'dart:io';

import 'package:dms/ui/start_my_day/bloc/start_my_day_events.dart';
import 'package:dms/ui/start_my_day/bloc/start_my_day_states.dart';
import 'package:dms/ui/start_my_day/model/quotes_and_images_response.dart';
import 'package:dms/ui/start_my_day/model/start_my_day_response.dart.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

import '../../../main.dart';

class StartMyDayBloc extends Bloc<StartMyDayEvents, StartMyDayStates> {
  StartMyDayBloc() : super(StartMyDayInitialState());

  @override
  Stream<StartMyDayStates> mapEventToState(StartMyDayEvents event) async* {
    if (event is GetQuotesAndImagesEvent) {
      yield StartMyDayLoadingState();
      yield* getQuotesAndImages(event);
    }
    if (event is StartMyDayEvent) {
      yield* startMyDay(event);
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
      String userId =
          await SharedPreference.getStringPreference(SharedPreference.userId);
      DateTime _ntpTime;
      _ntpTime = await NTP.now();
      var format = DateFormat("yyyy-MM-dd");
      StartMyDayResponse response = await repository.startMyDay(
        userId,
        format.format(_ntpTime).toString(),
        event.primaryTag,
        event.secondaryTag,
        event.remark,
        event.latitude,
        event.longitude,
        event.getMeeting,
        File(event.startDayImage),
        event.primaryTagId,
        event.secondaryTagId,
      );

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
}
