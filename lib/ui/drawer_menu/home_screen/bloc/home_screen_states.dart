import 'package:dms/ui/drawer_menu/home_screen/model/get_menus_response.dart';
import 'package:dms/ui/drawer_menu/home_screen/model/user_details_response.dart';
import 'package:equatable/equatable.dart';

class HomeScreenStates extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeScreenInitialState extends HomeScreenStates {}

class HomeScreenlodaingState extends HomeScreenStates {}

class HomeScreenFailureState extends HomeScreenStates {
  final String failureMessage;
  HomeScreenFailureState({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}

class GetUserDetailsSuccessState extends HomeScreenStates {
  final UserDetails userDetails;
  GetUserDetailsSuccessState({required this.userDetails});
  @override
  List<Object> get props => [userDetails];
}

class GetMenusState extends HomeScreenStates {
  final List<MenuData> menu;
  GetMenusState({required this.menu});
  @override
  List<Object> get props => [menu];
}
