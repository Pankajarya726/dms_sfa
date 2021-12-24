import 'package:dms/ui/splash_screen/model/splash_model.dart';
import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SplashInitialState extends SplashState {}

class SplashSuccessState extends SplashState {
  final SplashResponse response;
  SplashSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class SplashFailureState extends SplashState {
  final SplashResponse response;
  SplashFailureState({required this.response});
  @override
  List<Object?> get props => [response];
}

class SplashNetworkState extends SplashState {
  final String message;
  SplashNetworkState({required this.message});
  @override
  List<Object?> get props => [message];
}
