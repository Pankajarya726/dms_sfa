import 'package:equatable/equatable.dart';

class MyProfileDetailsEvents extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class MyProfileDetailsInitialEvent extends MyProfileDetailsEvents {
  final String currentDate;
  MyProfileDetailsInitialEvent({required this.currentDate});
  @override
  List<Object?> get props => [currentDate];
}

class MyProfileDetailsSelectDateEvent extends MyProfileDetailsEvents {
  final DateTime dateTime;
  MyProfileDetailsSelectDateEvent({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class MyProfileDetailsIncrementDateEvent extends MyProfileDetailsEvents {
  final DateTime dateTime;
  MyProfileDetailsIncrementDateEvent({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class MyProfileDetailsDecrementDateEvent extends MyProfileDetailsEvents {
  final DateTime dateTime;
  MyProfileDetailsDecrementDateEvent({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}
