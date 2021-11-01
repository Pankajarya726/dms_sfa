import 'package:equatable/equatable.dart';

class EditProfileEvent extends Equatable {
  final String name;
  final String emailId;
  final String imgFile;
  const EditProfileEvent(
      {required this.name, required this.emailId, required this.imgFile});
  @override
  List<Object?> get props => [name, emailId, imgFile];
}
