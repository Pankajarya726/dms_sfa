import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/absent/bloc/absent_events.dart';
import 'package:sfa/ui/absent/bloc/absent_states.dart';
import 'package:sfa/ui/absent/bloc/model/mark_absent_by_user.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';
import 'package:sfa/utility/network.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class AbsentBloc extends Bloc<AbsentEvents, AbsentStates> {
  AbsentBloc() : super(AbsentInitialState());

  @override
  Stream<AbsentStates> mapEventToState(AbsentEvents event) async* {
    if (event is AbsentInitialEvent) {
      yield AbsentLoadingState();
      yield* getInitialData(event);
    }
    if (event is AbsentSuccessEvent) {
      yield AbsentLoadingState();
      yield* callAbsentApi(event);
    }
  }

  Stream<AbsentStates> getInitialData(AbsentInitialEvent event) async* {
    if (await Network.isConnected()) {
      String userId = await SharedPrefrence.getStringPreference("id");
      UserDetails response = await repository.getUserDetailsByUserId(userId);

      if (response.success) {
        yield AbsentInitialSuccessState(userData: response);
      } else {
        yield AbsentFailureState(failureMessage: response.message);
      }
    } else {
      yield AbsentNetworkFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }

  Stream<AbsentStates> callAbsentApi(AbsentSuccessEvent event) async* {
    if (await Network.isConnected()) {
      String userId = await SharedPrefrence.getStringPreference("id");
      DateTime _ntpTime;
      _ntpTime = await NTP.now();
      var format = DateFormat("yyyy-M-dd");
      MarkAbsentByUserResponse response = await repository.markAbsentByUser(
          userId, format.format(_ntpTime).toString(), event.absentReason);
      if (response.success) {
        yield AbsentSuccessState(markAbsentByUserResponse: response);
      } else {
        yield AbsentFailureState(failureMessage: response.message);
      }
    } else {
      yield AbsentNetworkFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }
}
