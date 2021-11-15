import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sfa/provider/repository.dart';
import 'package:sfa/ui/absent/bloc/absent_events.dart';
import 'package:sfa/ui/absent/bloc/absent_states.dart';
import 'package:sfa/ui/absent/bloc/model/mark_absent_by_user.dart';
import 'package:sfa/utility/network.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class AbsentBloc extends Bloc<AbsentEvents, AbsentStates> {
  AbsentBloc() : super(AbsentInitialState());
  ApiRepository apiRepository = ApiRepository();

  @override
  Stream<AbsentStates> mapEventToState(AbsentEvents event) async* {
    if (event is AbsentSuccessEvent) {
      yield AbsentLoadingState();
      yield* callAbsentApi(event);
    }
  }

  Stream<AbsentStates> callAbsentApi(AbsentSuccessEvent event) async* {
    if (await Network.isConnected()) {
      String userId = await SharedPrefrence.getStringPreference("id");
      DateTime _ntpTime;
      _ntpTime = await NTP.now();
      var format = DateFormat("yyyy-M-dd");
      MarkAbsentByUserResponse response = await apiRepository.markAbsentByUser(
          userId, format.format(_ntpTime).toString(), event.absentReason);
      if (response.success) {
        yield AbsentSuccessState(markAbsentByUserResponse: response);
      } else {
        yield AbsentFailureState(failureMessage: response.message);
      }
    } else {
      yield AbsentFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }
}
