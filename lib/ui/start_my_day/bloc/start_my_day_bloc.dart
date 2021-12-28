import 'package:dms/ui/start_my_day/bloc/start_my_day_events.dart';
import 'package:dms/ui/start_my_day/bloc/start_my_day_states.dart';
import 'package:dms/ui/start_my_day/model/end_my_day_response.dart';
import 'package:dms/ui/start_my_day/model/quotes_and_images_response.dart';
import 'package:dms/ui/start_my_day/model/start_my_day_response.dart.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
      String address = "";

      try {
        EasyLoading.show();
        Position position = await location();
        EasyLoading.dismiss();

        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        Placemark place = placemarks[0];
        String locality = place.locality!;
        String name = place.name!;
        String postalCode = place.postalCode!;
        String street = place.street!;
        String subLocality = place.subLocality!;

        // In some cases, street and name are same, to handle this situation we applied this condition
        if (street == name) {
          address =
              street + " " + subLocality + " " + locality + " " + postalCode;
        } else {
          address = street +
              " " +
              name +
              " " +
              subLocality +
              " " +
              locality +
              " " +
              postalCode;
        }
      } catch (exception) {
        // yield EndMyDayFailureState(
        //     failureMessage: "Please turn on GPS location to end day");
      }

      EasyLoading.show();
      EndMyDayResponse response = await repository.endMyDay(
        userId,
        DateFormat("yyyy-MM-dd").format(_ntpTime),
        webtime,
        address,
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

  Future<Position> location() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please turn on the location for continue!");
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
