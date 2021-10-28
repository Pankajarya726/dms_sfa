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
  const TeamMemberTrackScreen({Key? key}) : super(key: key);

  @override
  _TeamMemberTrackScreenState createState() => _TeamMemberTrackScreenState();
}

class _TeamMemberTrackScreenState extends State<TeamMemberTrackScreen> {
  List<Marker> markers = [];
  TrackBloc trackBloc = TrackBloc();
  late GoogleMapController googleMapController;
  LatLng? currenPosition;
  Location location = Location();
  @override
  void initState() {
    trackBloc.add(TrackEvent(
        id: "16", date: DateFormat("yyyy-MM-dd").format(DateTime.now())));
    super.initState();
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
    return BlocProvider<TrackBloc>(
      create: (context) => trackBloc,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
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
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (state is TrackFailureState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text(state.message),
                    ),
                  );
                }
                if (state is TrackSuccessState) {
                  currenPosition = LatLng(
                      double.parse(state.response.data![0].latitude),
                      double.parse(state.response.data![0].longitude));

                  return GoogleMap(
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
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
