import 'dart:io';

import 'package:equatable/equatable.dart';

class CommonBlocEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class CommonBlocGetMeetingEvent extends CommonBlocEvents {
  final bool getMeeting;
  CommonBlocGetMeetingEvent({required this.getMeeting});
  @override
  List<Object> get props => [getMeeting];
}

class CommonBlocSelectImageEvent extends CommonBlocEvents {
  final File imageFile;
  CommonBlocSelectImageEvent({required this.imageFile});
  @override
  List<Object> get props => [imageFile];
}

class CommonBlocSelectOwnerImageEvent extends CommonBlocEvents {
  final File imageFile;
  CommonBlocSelectOwnerImageEvent({required this.imageFile});
  @override
  List<Object> get props => [imageFile];
}

class CommonBlocEnrollTypeRadioEvent extends CommonBlocEvents {
  final Object enrollmentRadioTag;
  CommonBlocEnrollTypeRadioEvent({required this.enrollmentRadioTag});
  @override
  List<Object> get props => [enrollmentRadioTag];
}

class CommonBlocRetailerRadioEvent extends CommonBlocEvents {
  final Object retailerRadioTag;
  CommonBlocRetailerRadioEvent({required this.retailerRadioTag});
  @override
  List<Object> get props => [retailerRadioTag];
}

class CommonBlocWhatsAppRadioEvent extends CommonBlocEvents {
  final Object whatsAppRadioTag;
  CommonBlocWhatsAppRadioEvent({required this.whatsAppRadioTag});
  @override
  List<Object> get props => [whatsAppRadioTag];
}

class CommonBlocIsKRORadioEvent extends CommonBlocEvents {
  final Object isKRORadioTag;
  CommonBlocIsKRORadioEvent({required this.isKRORadioTag});
  @override
  List<Object> get props => [isKRORadioTag];
}

class CommonBlocBirthdayEvent extends CommonBlocEvents {
  final DateTime dateTime;
  CommonBlocBirthdayEvent({required this.dateTime});
  @override
  List<Object> get props => [dateTime];
}

class CommonBlocAnniversaryEvent extends CommonBlocEvents {
  final DateTime dateTime;
  CommonBlocAnniversaryEvent({required this.dateTime});
  @override
  List<Object> get props => [dateTime];
}
