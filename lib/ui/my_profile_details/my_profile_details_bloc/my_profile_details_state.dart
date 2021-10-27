import 'package:equatable/equatable.dart';

class MyProfileDetailsState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class MyProfileDetailsInitialState extends MyProfileDetailsState {}

class MyProfileDetailsSelectDateState extends MyProfileDetailsState {
  final DateTime dateTime;
  MyProfileDetailsSelectDateState({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class MyProfileDetailsIncrementDateState extends MyProfileDetailsState {
  final DateTime dateTime;
  MyProfileDetailsIncrementDateState({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class MyProfileDetailsDecrementDateState extends MyProfileDetailsState {
  final DateTime dateTime;
  MyProfileDetailsDecrementDateState({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}
