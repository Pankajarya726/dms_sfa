import 'package:dms/ui/edit_profile/model/update_profile_response.dart';
import 'package:equatable/equatable.dart';

class EditProfileState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class EditProfileInitialState extends EditProfileState {}

class EditProfileLoadingState extends EditProfileState {}

class EditProfileSuccessState extends EditProfileState {
  final User user;
  EditProfileSuccessState({required this.user});
  @override
  List<Object?> get props => [user];
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

class GetUserDetailsSuccessState extends EditProfileState {
  final User user;
  GetUserDetailsSuccessState({required this.user});
  @override
  List<Object?> get props => [user];
}

class GetUserDetailsFailureState extends EditProfileState {
  final String message;
  GetUserDetailsFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
