import 'dart:io';

import 'package:equatable/equatable.dart';

class CommonBlocStates extends Equatable {
  @override
  List<Object> get props => [];
}

class CommonBlocInitialState extends CommonBlocStates {}

class CommonBlocLoadingState extends CommonBlocStates {}

class CommonBlocGetMeetingState extends CommonBlocStates {
  final bool getMeeting;
  CommonBlocGetMeetingState({required this.getMeeting});
  @override
  List<Object> get props => [getMeeting];
}

class CommonBlocSelectImageState extends CommonBlocStates {
  final File imageFile;
  CommonBlocSelectImageState({required this.imageFile});
  @override
  List<Object> get props => [imageFile];
}

class CommonBlocSelectOwnerImageState extends CommonBlocStates {
  final File imageFile;
  CommonBlocSelectOwnerImageState({required this.imageFile});
  @override
  List<Object> get props => [imageFile];
}

class CommonBlocEnrollRadioTagState extends CommonBlocStates {
  final Object enrollmentRadioTag;
  CommonBlocEnrollRadioTagState({required this.enrollmentRadioTag});
  @override
  List<Object> get props => [enrollmentRadioTag];
}

class CommonBlocRetailerRadioState extends CommonBlocStates {
  final Object retailerRadioTag;
  CommonBlocRetailerRadioState({required this.retailerRadioTag});
  @override
  List<Object> get props => [retailerRadioTag];
}

class CommonBlocWhatsAppRadioState extends CommonBlocStates {
  final String whatsAppRadioTag;
  CommonBlocWhatsAppRadioState({required this.whatsAppRadioTag});
  @override
  List<Object> get props => [whatsAppRadioTag];
}

class CommonBlocIsKRORadioState extends CommonBlocStates {
  final Object isKRORadioTag;
  CommonBlocIsKRORadioState({required this.isKRORadioTag});
  @override
  List<Object> get props => [isKRORadioTag];
}

class CommonBlocBirthdayState extends CommonBlocStates {
  final DateTime dateTime;
  CommonBlocBirthdayState({required this.dateTime});
  @override
  List<Object> get props => [dateTime];
}

class CommonBlocAnniversaryState extends CommonBlocStates {
  final DateTime dateTime;
  CommonBlocAnniversaryState({required this.dateTime});
  @override
  List<Object> get props => [dateTime];
}

class CommonBlocCurrentDateState extends CommonBlocStates {
  final DateTime currentDate;
  CommonBlocCurrentDateState({required this.currentDate});
  @override
  List<Object> get props => [currentDate];
}
