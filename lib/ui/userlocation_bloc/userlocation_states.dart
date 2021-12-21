import 'package:equatable/equatable.dart';

class UserLocationStates extends Equatable {
  @override
  List<Object> get props => [];
}

class UserLocationInitialState extends UserLocationStates {}

class GetUserLocationState extends UserLocationStates {
  final String currentAddress;
  final double latitude;
  final double longitude;
  GetUserLocationState(
      {required this.currentAddress,
      required this.latitude,
      required this.longitude});
  @override
  List<Object> get props => [currentAddress, latitude, longitude];
}

class UserLocationFailureState extends UserLocationStates {
  final String failureMessage;
  UserLocationFailureState({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}
