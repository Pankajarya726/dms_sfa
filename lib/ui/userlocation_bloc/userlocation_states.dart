import 'package:equatable/equatable.dart';

class UserLocationStates extends Equatable {
  @override
  List<Object> get props => [];
}

class UserLocationInitialState extends UserLocationStates {}

class UserLocationLoadingState extends UserLocationStates {}

class GetUserLocationState extends UserLocationStates {
  final String currentAddress;
  final double latitude;
  final double longitude;
  final String pincode;
  GetUserLocationState({
    required this.currentAddress,
    required this.latitude,
    required this.longitude,
    required this.pincode,
  });
  @override
  List<Object> get props => [currentAddress, latitude, longitude, pincode];
}

class UserLocationFailureState extends UserLocationStates {
  final String failureMessage;
  UserLocationFailureState({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}
