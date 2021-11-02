import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/my_profile_attendence/my_profile_attendence_bloc/my_profile_attendence_event.dart';
import 'package:sfa/ui/my_profile_attendence/my_profile_attendence_bloc/my_profile_attendence_state.dart';
import 'package:sfa/ui/team_member_attendence/model/attendance_model.dart';
import 'package:sfa/utility/network.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class MyProfileAttendenceBloc
    extends Bloc<MyProfileAttendenceEvents, MyProfileAttendenceState> {
  MyProfileAttendenceBloc() : super(MyProfileAttendenceInitialState());
  @override
  Stream<MyProfileAttendenceState> mapEventToState(
      MyProfileAttendenceEvents event) async* {
    if (event is MyProfileAttendenceInitialEvent) {
      yield MyProfileAttendenceLoadingState();
      yield* getMyProfileAttendenceData(event);
    }
    if (event is MyProfileAttendenceSelectDateEvent) {
      yield MyProfileAttendenceLoadingState();
      yield MyProfileAttendenceSelectDateState(dateTime: event.dateTime);
    }
    if (event is MyProfileAttendenceIncrementDateEvent) {
      yield MyProfileAttendenceLoadingState();
      yield MyProfileAttendenceIncrementDateState(dateTime: event.dateTime);
    }
    if (event is MyProfileAttendenceDecrementDateEvent) {
      yield MyProfileAttendenceLoadingState();
      yield MyProfileAttendenceDecrementDateState(dateTime: event.dateTime);
    }
  }

  Stream<MyProfileAttendenceState> getMyProfileAttendenceData(
      MyProfileAttendenceInitialEvent event) async* {
    if (await Network.isConnected()) {
      var userId = await SharedPrefrence.getStringPreference("id");
      AttendanceResponse response =
          await repository.getTeamMembersAttendence(userId, event.currentDate);
      if (response.success) {
        List<AttendenceModel> attendenceList = [];

        attendenceList.addAll(response.clockInData!);
        attendenceList.addAll(response.absentData!);
        attendenceList.sort((a, b) => a.date!.compareTo(b.date!));

        yield MyProfileAttendenceInitialSuccessState(
            attendanceResponse: attendenceList);
      } else {
        yield MyProfileAttendenceFailureState(failureMessage: response.message);
      }
    } else {
      yield MyProfileAttendenceFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }
}
