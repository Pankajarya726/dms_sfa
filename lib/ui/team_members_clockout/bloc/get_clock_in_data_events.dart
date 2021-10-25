import 'package:equatable/equatable.dart';

class GetClockInDataEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetClockInDataSuccessEvent extends GetClockInDataEvents {
  final String dateAdded;
  GetClockInDataSuccessEvent({required this.dateAdded});
  @override
  List<Object?> get props => [dateAdded];
}
