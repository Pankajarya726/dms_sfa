import 'dart:io';

import 'package:equatable/equatable.dart';

class EditProfileEvents extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class EditProfileEvent extends EditProfileEvents {
  final String name;
  final String emailId;
  final File? imgFile;
  EditProfileEvent({required this.name, required this.emailId, this.imgFile});
  @override
  List<Object?> get props => [name, emailId, imgFile];
}

class GetUserDetailsEvent extends EditProfileEvents {
  GetUserDetailsEvent();
  @override
  List<Object?> get props => [];
}
