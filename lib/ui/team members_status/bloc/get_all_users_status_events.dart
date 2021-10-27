import 'package:equatable/equatable.dart';

class GetAllUserStatusEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllUserStatusInitialEvent extends GetAllUserStatusEvents {
  final String statusDate;
  GetAllUserStatusInitialEvent({required this.statusDate});
  @override
  List<Object?> get props => [statusDate];
}
