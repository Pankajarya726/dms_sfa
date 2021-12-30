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
