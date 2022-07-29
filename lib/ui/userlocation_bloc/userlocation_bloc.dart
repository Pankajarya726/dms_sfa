import 'package:dms/ui/userlocation_bloc/userlocation_events.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location;

class UserLocationBloc extends Bloc<UserLocationEvents, UserLocationStates> {
  UserLocationBloc() : super(UserLocationInitialState());

  @override
  Stream<UserLocationStates> mapEventToState(UserLocationEvents event) async* {
    debugPrint("event--->$event");
    if (event is GetUserLocationEvent) {
      yield UserLocationLoadingState();
      yield* getUserLocation(event);
    }
  }

  Stream<UserLocationStates> getUserLocation(GetUserLocationEvent event) async* {
    try {
      location.LocationData? position = await getLocation();

      debugPrint("position--->$position");
      if (position != null) {
        double latitude = position.latitude!;
        double longitude = position.longitude!;
        //22.83148761129894 75.79094411948394
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude!, position.longitude!);
        // List<Placemark> placemarks = await placemarkFromCoordinates(22.83148761129894, 75.79094411948394);
        Placemark place = placemarks[0];

        debugPrint("place-->${place.toString()}");

        String locality = place.locality ?? "";
        String name = place.name ?? "";
        String postalCode = place.postalCode ?? "";
        String street = place.street ?? "";
        String subLocality = place.subLocality ?? "";
        String address;

        // In some cases, street and name are same, to handle this situation we applied this condition
        if (street == name) {
          if (street.isNotEmpty) {
            street = street + ", ";
            if (street.toLowerCase().contains("unnamed")) {
              street = "";
            }
          }
          if (subLocality.isNotEmpty) {
            subLocality = subLocality + ", ";
          }
          if (locality.isNotEmpty) {
            locality = locality + ", ";
          }

          address = street + subLocality + locality + postalCode;
        } else {
          if (street.isNotEmpty) {
            street = street + ", ";
            if (street.toLowerCase().contains("unnamed")) {
              street = "";
            }
          }
          if (name.isNotEmpty) {
            name = name + ", ";
            if (name.toLowerCase().contains("unnamed")) {
              street = "";
            }
          }
          if (subLocality.isNotEmpty) {
            subLocality = subLocality + ", ";
          }
          if (locality.isNotEmpty) {
            locality = locality + ", ";
          }
          address = street + name + subLocality + locality + postalCode;
        }

        yield GetUserLocationState(
            currentAddress: address, latitude: latitude, longitude: longitude, pincode: postalCode, locality: locality, place: place);
      } else {
        yield UserLocationFailureState(failureMessage: "Click here to get current location!");
      }
    } catch (exception) {
      debugPrint("exception-->$exception");
      yield UserLocationFailureState(failureMessage: "Click here to get current location!");
    }
  }

  Future<location.LocationData?> getLocation() async {
    bool serviceEnabled;
    location.Location mLocation = location.Location();

    // Test if location services are enabled.
    serviceEnabled = await mLocation.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await mLocation.requestService();
    }

    debugPrint("serviceEnabled--->$serviceEnabled");

    location.PermissionStatus permission = await mLocation.hasPermission();

    debugPrint("permission--->$permission");

    if (permission == location.PermissionStatus.denied) {
      permission = await mLocation.requestPermission();
      debugPrint("requestPermissionResult--->$permission");
      if (permission == location.PermissionStatus.denied) {
        Fluttertoast.showToast(
            msg: "Location permission are denied, Please enable location permission to continue.", toastLength: Toast.LENGTH_LONG);
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == location.PermissionStatus.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Fluttertoast.showToast(
          msg: "Location permission are permanently denied go to app settings and allow gps location permission",
          toastLength: Toast.LENGTH_LONG);
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    debugPrint("continue--->");
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    location.LocationData l = await mLocation.getLocation().catchError((exception) {
      debugPrint("exception in getting location--->$exception");
    });
    debugPrint("location--->$l");
    return l;
  }
}
