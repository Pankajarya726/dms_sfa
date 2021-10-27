import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/ui/my_profile_attendence/my_profile_attendence_bloc/my_profile_attendence_event.dart';
import 'package:sfa/ui/my_profile_attendence/my_profile_attendence_bloc/my_profile_attendence_state.dart';

class MyProfileAttendenceBloc
    extends Bloc<MyProfileAttendenceEvents, MyProfileAttendenceState> {
  MyProfileAttendenceBloc() : super(MyProfileAttendenceInitialState());
  @override
  Stream<MyProfileAttendenceState> mapEventToState(
      MyProfileAttendenceEvents event) async* {
    if (event is MyProfileAttendenceSelectDateEvent) {
      yield MyProfileAttendenceSelectDateState(dateTime: event.dateTime);
    }
    if (event is MyProfileAttendenceIncrementDateEvent) {
      yield MyProfileAttendenceIncrementDateState(dateTime: event.dateTime);
    }
    if (event is MyProfileAttendenceDecrementDateEvent) {
      yield MyProfileAttendenceDecrementDateState(dateTime: event.dateTime);
    }
  }
}
