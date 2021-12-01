import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:sfa/ui/team_member_track_screen/track_bloc/track_bloc.dart';
import 'package:sfa/ui/team_member_track_screen/track_bloc/track_event.dart';
import 'package:sfa/ui/team_member_track_screen/track_bloc/track_state.dart';
import 'package:sfa/utility/colors.dart';

class TeamMemberTrackScreen extends StatefulWidget {
  String userId;
  TeamMemberTrackScreen({required this.userId, Key? key}) : super(key: key);

  @override
  _TeamMemberTrackScreenState createState() => _TeamMemberTrackScreenState();
}

class _TeamMemberTrackScreenState extends State<TeamMemberTrackScreen> {
  Set<Marker> markers = {};
  TrackBloc trackBloc = TrackBloc();
  late GoogleMapController googleMapController;
  LatLng? currenPosition;
  List<LatLng> markerPosition = [];
  Location location = Location();

  @override
  void initState() {
    getData();
    super.initState();
  }

  addMarker(List<LatLng> currentPositions, clockInLatitude, clockInLongitude) {
    for (int i = 0; i < currentPositions.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId(currentPositions[i].toString()),
          position: currentPositions[i],
          draggable: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(currentPositions[i] ==
                  LatLng(
                    double.parse(clockInLatitude),
                    double.parse(clockInLongitude),
                  )
              ? BitmapDescriptor.hueGreen
              : BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrackBloc>(
      create: (context) => trackBloc,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: reportBG,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BlocBuilder<TrackBloc, TrackState>(
              builder: (context, state) {
                if (state is TrackLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is TrackFailureState) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                if (state is TrackSuccessState) {
                  markers.add(
                    Marker(
                        markerId:
                            MarkerId(state.response.data[0].clockInLatitude),
                        position: LatLng(
                            double.parse(
                                state.response.data[0].clockInLatitude),
                            double.parse(
                                state.response.data[0].clockInLongitude))),
                  );

                  Marker(
                      markerId:
                          MarkerId(state.response.data[0].clockOutLatitude),
                      position: LatLng(
                          double.parse(state.response.data[0].clockOutLatitude),
                          double.parse(
                              state.response.data[0].clockOutLongitude)));

                  markerPosition.add(LatLng(
                      double.parse(state.response.data[0].clockInLatitude),
                      double.parse(state.response.data[0].clockInLongitude)));
                  markerPosition.add(LatLng(
                      double.parse(state.response.data[0].clockOutLatitude),
                      double.parse(state.response.data[0].clockOutLongitude)));

                  if (state.response.data[0].inOutStatus == 1) {
                    currenPosition = LatLng(
                        double.parse(state.response.data[0].clockInLatitude),
                        double.parse(state.response.data[0].clockInLongitude));
                  }
                  if (state.response.data[0].inOutStatus == 2) {
                    currenPosition = LatLng(
                        double.parse(state.response.data[0].clockOutLatitude),
                        double.parse(state.response.data[0].clockOutLongitude));
                  }
                  if (state.response.data[0].inOutStatus == 3) {
                    return const Center(
                      child: Text("Employee is absent"),
                    );
                  }

                  return currenPosition != null
                      ? GoogleMap(
                          tiltGesturesEnabled: true,
                          mapType: MapType.normal,
                          compassEnabled: true,
                          zoomControlsEnabled: true,
                          scrollGesturesEnabled: true,
                          zoomGesturesEnabled: true,
                          markers: markers,
                          initialCameraPosition: CameraPosition(
                              target: currenPosition!, zoom: 14.0),
                          onMapCreated: (controller) {
                            setState(
                              () {
                                googleMapController = controller;
                                addMarker(
                                    markerPosition,
                                    state.response.data[0].clockInLatitude,
                                    state.response.data[0].clockInLongitude);
                              },
                            );
                          },
                        )
                      : Container();
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  void getData() {
    trackBloc.add(TrackEvent(
        id: widget.userId,
        date: DateFormat("yyyy-MM-dd").format(DateTime.now())));
  }
}
