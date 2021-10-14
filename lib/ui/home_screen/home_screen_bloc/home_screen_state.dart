import 'package:equatable/equatable.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';

class HomeScreenState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class HomeScreenInitialState extends HomeScreenState {}

class HomeScreenLoadingState extends HomeScreenState {}

class HomeScreenSuccessState extends HomeScreenState {
  final UserData userData;
  HomeScreenSuccessState({required this.userData});
  @override
  List<Object?> get props => [userData];
}

class HomeScreenFailureState extends HomeScreenState {
  final String messages;
  HomeScreenFailureState({required this.messages});
}
