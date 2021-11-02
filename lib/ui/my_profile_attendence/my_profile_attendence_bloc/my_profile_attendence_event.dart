import 'package:equatable/equatable.dart';

class MyProfileAttendenceEvents extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class MyProfileAttendenceInitialEvent extends MyProfileAttendenceEvents {
  final String currentDate;
  MyProfileAttendenceInitialEvent({required this.currentDate});
  @override
  List<Object?> get props => [currentDate];
}

class MyProfileAttendenceSelectDateEvent extends MyProfileAttendenceEvents {
  final DateTime dateTime;
  MyProfileAttendenceSelectDateEvent({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class MyProfileAttendenceIncrementDateEvent extends MyProfileAttendenceEvents {
  final DateTime dateTime;
  MyProfileAttendenceIncrementDateEvent({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class MyProfileAttendenceDecrementDateEvent extends MyProfileAttendenceEvents {
  final DateTime dateTime;
  MyProfileAttendenceDecrementDateEvent({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}
