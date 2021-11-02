import 'package:equatable/equatable.dart';

class EditProfileEvents extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class EditProfileEvent extends EditProfileEvents {
  final String name;
  final String emailId;
  final String imgFile;
  EditProfileEvent(
      {required this.name, required this.emailId, required this.imgFile});
  @override
  List<Object?> get props => [name, emailId, imgFile];
}

class GetUserDetailsEvent extends EditProfileEvents {
  final String userId;
  GetUserDetailsEvent({required this.userId});
  @override
  List<Object?> get props => [userId];
}
