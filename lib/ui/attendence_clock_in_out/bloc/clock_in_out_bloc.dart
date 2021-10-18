import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_events.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_states.dart';

class ClockInOutBloc extends Bloc<ClockInOutEvents, ClockInOutStates> {
  ClockInOutBloc() : super(ClockInOutInitialState());

  @override
  Stream<ClockInOutStates> mapEventToState(event) async* {
    if (event is ClockInOutSuccessEvent) {
      DateTime _ntpTime;
      _ntpTime = await NTP.now();
      var format = DateFormat("dd-MMM-yyyy");

      yield ClockInOutSuccessState(
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
