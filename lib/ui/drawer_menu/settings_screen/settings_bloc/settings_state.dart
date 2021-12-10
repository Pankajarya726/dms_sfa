import 'package:dms/ui/drawer_menu/home_screen/model/home_screen_model.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SettingsInitialState extends SettingsState {}

class DetailsSucessState extends SettingsState {
  final UserDetails response;
  DetailsSucessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class DetailsFailureState extends SettingsState {
  final String message;
  DetailsFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
