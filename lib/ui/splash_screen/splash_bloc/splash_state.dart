import 'package:equatable/equatable.dart';
import 'package:sfa/ui/splash_screen/model/splash_model.dart';

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
  final String message;
  SplashFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}

class SplashNetworkState extends SplashState {
  final String message;
  SplashNetworkState({required this.message});
  @override
  List<Object?> get props => [message];
}
