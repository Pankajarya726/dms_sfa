import 'package:equatable/equatable.dart';
import 'package:sfa/ui/edit_profile/model/edit_profile_model.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';

class EditProfileState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class EditProfileInitialState extends EditProfileState {}

class EditProfileLoadingState extends EditProfileState {}

class EditProfileSuccessState extends EditProfileState {
  final EditProfileResponse response;
  EditProfileSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class EditProfileFailureState extends EditProfileState {
  final String message;
  EditProfileFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}

class EditProfileNetworkState extends EditProfileState {
  final String message;
  EditProfileNetworkState({required this.message});
  @override
  List<Object?> get props => [message];
}

class GetUserDetailsSucessState extends EditProfileState {
  final UserData response;
  GetUserDetailsSucessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class GetUserDetailsFailureState extends EditProfileState {
  final String message;
  GetUserDetailsFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
