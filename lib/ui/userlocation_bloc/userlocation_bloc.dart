import 'package:dms/ui/userlocation_bloc/userlocation_events.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class UserLocationBloc extends Bloc<UserLocationEvents, UserLocationStates> {
  UserLocationBloc() : super(UserLocationInitialState());

  @override
  Stream<UserLocationStates> mapEventToState(UserLocationEvents event) async* {
    if (event is GetUserLocationEvent) {
      yield UserLocationLoadingState();
      yield* getUserLocation(event);
    }
  }

  Stream<UserLocationStates> getUserLocation(
      GetUserLocationEvent event) async* {
    try {
      Position position = await location();
      double latitude = position.latitude;
      double longitude = position.longitude;
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      String locality = place.locality!;
      String name = place.name!;
      String postalCode = place.postalCode!;
      String street = place.street!;
      String subLocality = place.subLocality!;
      String address;

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

      yield GetUserLocationState(
          currentAddress: address, latitude: latitude, longitude: longitude);
    } catch (exception) {
      yield UserLocationFailureState(
          failureMessage: "Click here to get current location!");
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
