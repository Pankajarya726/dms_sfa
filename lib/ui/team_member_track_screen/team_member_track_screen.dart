import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sfa/utility/colors.dart';

class TeamMemberTrackScreen extends StatefulWidget {
  const TeamMemberTrackScreen({Key? key}) : super(key: key);

  @override
  _TeamMemberTrackScreenState createState() => _TeamMemberTrackScreenState();
}

class _TeamMemberTrackScreenState extends State<TeamMemberTrackScreen> {
  List<Marker> markers = [];
  late GoogleMapController googleMapController;
  LatLng? currenPosition;
  Location location = Location();
  @override
  void initState() {
    getUserLocation();
    super.initState();
  }

  getUserLocation() async {
    await location.requestPermission();
    PermissionStatus status = await location.hasPermission();

    if (status == PermissionStatus.granted) {
      LocationData position = await location.getLocation();
      setState(() {
        currenPosition = LatLng(position.latitude!, position.longitude!);
      });
      debugPrint("Current Position" + currenPosition.toString());
    }
  }

  addMarker(currenPosition) {
    setState(
      () {
        markers = [];
        markers.add(
          Marker(
            markerId: MarkerId(currenPosition.toString()),
            position: currenPosition,
            draggable: true,
            onDragEnd: (dragEndPosition) {},
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          color: reportBG,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: currenPosition != null
            ? ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: GoogleMap(
                  mapType: MapType.normal,
                  compassEnabled: true,
                  zoomControlsEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  markers: Set.from(markers),
                  initialCameraPosition:
                      CameraPosition(target: currenPosition!, zoom: 14.0),
                  onMapCreated: (controller) {
                    setState(
                      () {
                        googleMapController = controller;
                        addMarker(currenPosition);
                      },
                    );
                  },
                ),
              )
            : Container(),
      ),
    );
  }
}
