import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/team_member_track_screen/model/track_model.dart';
import 'package:sfa/ui/team_member_track_screen/track_bloc/track_event.dart';
import 'package:sfa/ui/team_member_track_screen/track_bloc/track_state.dart';
import 'package:sfa/utility/network.dart';

class TrackBloc extends Bloc<TrackEvent, TrackState> {
  TrackBloc() : super(TrackInitialState());
  @override
  Stream<TrackState> mapEventToState(TrackEvent event) async* {
    if (event is TrackEvent) {
      yield TrackLoadingState();
      yield* getData(event);
    }
  }

  Stream<TrackState> getData(TrackEvent event) async* {
    if (await Network.isConnected()) {
      TrackResponse response =
          await repository.getTrackData(event.id, event.date);

      if (response.success) {
        yield TrackSuccessState(response: response);
      } else {
        yield TrackFailureState(message: response.message);
      }
    } else {
      yield TrackFailureState(
          message: "Please check your internet connection!");
    }
  }
}
