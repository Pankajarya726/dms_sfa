import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';

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
    if (event is CommonBlocSelectOwnerImageEvent) {
      yield CommonBlocLoadingState();
      yield* selectOwnerImage(event);
    }
    if (event is CommonBlocEnrollTypeRadioEvent) {
      yield CommonBlocLoadingState();
      yield* enrollmentTypeRadioTag(event);
    }
    if (event is CommonBlocRetailerRadioEvent) {
      yield CommonBlocLoadingState();
      yield* retailerRadioTag(event);
    }
    if (event is CommonBlocWhatsAppRadioEvent) {
      yield CommonBlocLoadingState();
      yield* whatsAppRadioTag(event);
    }
    if (event is CommonBlocIsKRORadioEvent) {
      yield CommonBlocLoadingState();
      yield* isKRORadioTag(event);
    }
    if (event is CommonBlocBirthdayEvent) {
      yield CommonBlocLoadingState();
      yield* selectDateBirthday(event);
    }
    if (event is CommonBlocAnniversaryEvent) {
      yield CommonBlocLoadingState();
      yield* selectDateAnniversary(event);
    }
    if (event is CommonBlocCurrentDateEvent) {
      yield CommonBlocLoadingState();
      yield* getCurrentDate(event);
    }
  }

  Stream<CommonBlocStates> getMeeting(CommonBlocGetMeetingEvent event) async* {
    yield CommonBlocGetMeetingState(getMeeting: event.getMeeting);
  }

  Stream<CommonBlocStates> selectImage(
      CommonBlocSelectImageEvent event) async* {
    yield CommonBlocSelectImageState(imageFile: event.imageFile);
  }

  Stream<CommonBlocStates> selectOwnerImage(
      CommonBlocSelectOwnerImageEvent event) async* {
    yield CommonBlocSelectOwnerImageState(imageFile: event.imageFile);
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

  Stream<CommonBlocStates> whatsAppRadioTag(
      CommonBlocWhatsAppRadioEvent event) async* {
    yield CommonBlocWhatsAppRadioState(
        whatsAppRadioTag: event.whatsAppRadioTag);
  }

  Stream<CommonBlocStates> isKRORadioTag(
      CommonBlocIsKRORadioEvent event) async* {
    yield CommonBlocIsKRORadioState(isKRORadioTag: event.isKRORadioTag);
  }

  Stream<CommonBlocStates> selectDateBirthday(
      CommonBlocBirthdayEvent event) async* {
    yield CommonBlocBirthdayState(dateTime: event.dateTime);
  }

  Stream<CommonBlocStates> selectDateAnniversary(
      CommonBlocAnniversaryEvent event) async* {
    yield CommonBlocAnniversaryState(dateTime: event.dateTime);
  }

  Stream<CommonBlocStates> getCurrentDate(
      CommonBlocCurrentDateEvent event) async* {
    DateTime currentDate =
        await NTP.now().timeout(const Duration(seconds: 5), onTimeout: () {
      return DateTime.now();
    });
    yield CommonBlocCurrentDateState(currentDate: currentDate);
  }
}
