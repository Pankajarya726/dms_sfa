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
