import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommonBloc extends Bloc<CommonBlocEvents, CommonBlocStates> {
  CommonBloc() : super(CommonBlocInitialState());

  @override
  Stream<CommonBlocStates> mapEventToState(CommonBlocEvents event) async* {
    if (event is CommonBlocGetMeetingEvent) {
      yield CommonBlocLoadingState();
      yield* getMeeting(event);
    }

    if (event is CommonBlocSelectImageEvent) {
      yield CommonBlocLoadingState();
      yield* selectImage(event);
    }
    if (event is CommonBlocEnrollTypeRadioEvent) {
      yield CommonBlocLoadingState();
      yield* enrollmentTypeRadioTag(event);
    }
    if (event is CommonBlocRetailerRadioEvent) {
      yield CommonBlocLoadingState();
      yield* retailerRadioTag(event);
    }
    if (event is CommonBlocIsKRORadioEvent) {
      yield CommonBlocLoadingState();
      yield* isKRORadioTag(event);
    }
  }

  Stream<CommonBlocStates> getMeeting(CommonBlocGetMeetingEvent event) async* {
    yield CommonBlocGetMeetingState(getMeeting: event.getMeeting);
  }

  Stream<CommonBlocStates> selectImage(
      CommonBlocSelectImageEvent event) async* {
    yield CommonBlocSelectImageState(imageFile: event.imageFile);
  }

  Stream<CommonBlocStates> enrollmentTypeRadioTag(
      CommonBlocEnrollTypeRadioEvent event) async* {
    yield CommonBlocEnrollRadioTagState(
        enrollmentRadioTag: event.enrollmentRadioTag);
  }

  Stream<CommonBlocStates> retailerRadioTag(
      CommonBlocRetailerRadioEvent event) async* {
    yield CommonBlocRetailerRadioState(
        retailerRadioTag: event.retailerRadioTag);
  }

  Stream<CommonBlocStates> isKRORadioTag(
      CommonBlocIsKRORadioEvent event) async* {
    yield CommonBlocIsKRORadioState(isKRORadioTag: event.isKRORadioTag);
  }
}
