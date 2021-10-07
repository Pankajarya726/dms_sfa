import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TeamMemberTrackScreen extends StatefulWidget {
  const TeamMemberTrackScreen({Key? key}) : super(key: key);

  @override
  _TeamMemberTrackScreenState createState() => _TeamMemberTrackScreenState();
}

class _TeamMemberTrackScreenState extends State<TeamMemberTrackScreen> {
  List<Marker> markers = [];
  late GoogleMapController googleMapController;
  late LatLng currenPosition;

  @override
  void initState() {
    // getUserLocation();
    super.initState();
  }

  // getUserLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   setState(() {
  //     currenPosition = LatLng(position.latitude, position.longitude);
  //   });
  //   debugPrint("Current Position" + currenPosition.toString());
  // }

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
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: GoogleMap(
          mapType: MapType.normal,
          compassEnabled: true,
          zoomControlsEnabled: true,
          scrollGesturesEnabled: true,
          markers: Set.from(markers),
          initialCameraPosition:
              CameraPosition(target: currenPosition, zoom: 14.0),
          onMapCreated: (controller) {
            setState(() {
              googleMapController = controller;
              addMarker(currenPosition);
            });
          },
        ),
      ),
    );
  }
}
