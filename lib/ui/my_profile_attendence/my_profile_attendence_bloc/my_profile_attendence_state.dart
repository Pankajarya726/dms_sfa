import 'package:equatable/equatable.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_bloc/model/attendance_model.dart';

class MyProfileAttendenceState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class MyProfileAttendenceInitialState extends MyProfileAttendenceState {}

class MyProfileAttendenceFailureState extends MyProfileAttendenceState {
  final String failureMessage;
  MyProfileAttendenceFailureState({required this.failureMessage});
  @override
  List<Object?> get props => [failureMessage];
}

class MyProfileAttendenceLoadingState extends MyProfileAttendenceState {}

class MyProfileAttendenceInitialSuccessState extends MyProfileAttendenceState {
  final List<AttendenceModel> attendanceResponse;
  MyProfileAttendenceInitialSuccessState({required this.attendanceResponse});
  @override
  List<Object?> get props => [attendanceResponse];
}

class MyProfileAttendenceSelectDateState extends MyProfileAttendenceState {
  final DateTime dateTime;
  MyProfileAttendenceSelectDateState({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class MyProfileAttendenceIncrementDateState extends MyProfileAttendenceState {
  final DateTime dateTime;
  MyProfileAttendenceIncrementDateState({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class MyProfileAttendenceDecrementDateState extends MyProfileAttendenceState {
  final DateTime dateTime;
  MyProfileAttendenceDecrementDateState({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}
