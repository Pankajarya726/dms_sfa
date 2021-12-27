import 'package:dms/ui/edit_profile/model/update_profile_response.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SettingsInitialState extends SettingsState {}

class GetUserDetailsSuccessState extends SettingsState {
  final User user;
  GetUserDetailsSuccessState({required this.user});
  @override
  List<Object?> get props => [user];
}

class DetailsFailureState extends SettingsState {
  final String message;
  DetailsFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
