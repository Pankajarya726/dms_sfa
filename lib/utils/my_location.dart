// ignore_for_file: unused_local_variable

import 'package:dms/utils/utility.dart';
import 'package:location/location.dart';

class MyLocation {
  static Location mLocation = Location();

  static Future<LocationData?> getCurrentLocation() async {
    PermissionStatus permission;
    // Test if location services are enabled.
    // bool serviceEnabled = await mLocation.serviceEnabled();
    // if (!serviceEnabled) {
    //   serviceEnabled = await mLocation.requestService();
    // }

    permission = await mLocation.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await mLocation.requestPermission();
      if (permission == PermissionStatus.denied) {
        Utility.showToast("Please turn on the location for continue!");
        return Future.error('Location permissions are denied');
      }
    } else if (permission == PermissionStatus.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Utility.showToast("Location permissions are permanently denied, Please enable location permission from app settings");
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    } else {
      return await mLocation.getLocation();
    }
    return null;
  }
}
