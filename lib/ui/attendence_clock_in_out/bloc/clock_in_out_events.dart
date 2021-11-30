import 'package:equatable/equatable.dart';

class ClockInOutEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClockInOutInitialEvent extends ClockInOutEvents {
  @override
  List<Object?> get props => [];
}

class ClockInSuccessEvent extends ClockInOutEvents {
  final String inOutTime;
  final String workingPlan;
  final String selfieImage;
  final String latitude;
  final String longitude;
  final int workingPlanConfirmation;
  ClockInSuccessEvent(
      {required this.inOutTime,
      required this.workingPlan,
      required this.selfieImage,
      required this.latitude,
      required this.longitude,
      required this.workingPlanConfirmation});
  @override
  List<Object?> get props => [
        inOutTime,
        workingPlan,
        selfieImage,
        latitude,
        longitude,
        workingPlanConfirmation,
      ];
}

class ClockOutSuccessEvent extends ClockInOutEvents {
  final String inOutTime;
  final String workingPlan;
  final String selfieImage;
  final String latitude;
  final String longitude;

  ClockOutSuccessEvent({
    required this.inOutTime,
    required this.workingPlan,
    required this.selfieImage,
    required this.latitude,
    required this.longitude,
  });
  @override
  List<Object?> get props => [
        inOutTime,
        workingPlan,
        selfieImage,
        latitude,
        longitude,
      ];
}

class ClockInOutGetUserLocationEvent extends ClockInOutEvents {
  @override
  List<Object?> get props => [];
}
