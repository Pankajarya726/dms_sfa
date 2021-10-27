import 'package:equatable/equatable.dart';

class MyProfileAttendenceState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class MyProfileAttendenceInitialState extends MyProfileAttendenceState {}

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
