import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sfa/ui/attendence_clock_in_out/clock%20in%20bloc/clock_in_events.dart';
import 'package:sfa/ui/attendence_clock_in_out/clock%20in%20bloc/clock_in_states.dart';

class ClockInBloc extends Bloc<ClockInEvents, ClockInStates> {
  ClockInBloc() : super(ClockInInitialState());

  @override
  Stream<ClockInStates> mapEventToState(event) async* {
    if (event is ClockInSuccessEvent) {
      DateTime _ntpTime;
      _ntpTime = await NTP.now();
      var format = DateFormat("dd-MMM-yyyy");

      yield ClockInSuccessState(
        date: format.format(_ntpTime),
        at: " at ",
        seperator: ":",
        currentHours: _ntpTime.hour,
        currentMinutes: _ntpTime.minute,
        currentSeconds: _ntpTime.second,
      );
    }
  }
}
