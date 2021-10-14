import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sfa/ui/attendence_clock_in_out/clock%20out%20bloc/clock_out_events.dart';
import 'package:sfa/ui/attendence_clock_in_out/clock%20out%20bloc/clock_out_states.dart';

class ClockOutBloc extends Bloc<ClockOutEvents, ClockOutStates> {
  ClockOutBloc() : super(ClockOutInitialState());
  @override
  Stream<ClockOutStates> mapEventToState(ClockOutEvents event) async* {
    if (event is ClockOutSuccessEvent) {
      DateTime _ntpTime;
      _ntpTime = await NTP.now();
      var format = DateFormat("dd-MMM-yyyy");

      yield ClockOutSuccessState(
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
