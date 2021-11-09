import 'package:equatable/equatable.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';

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
