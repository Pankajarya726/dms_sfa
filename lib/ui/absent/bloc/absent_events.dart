import 'package:equatable/equatable.dart';

class AbsentEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class AbsentSuccessEvent extends AbsentEvents {
  final String absentReason;
  AbsentSuccessEvent({required this.absentReason});

  @override
  List<Object?> get props => [absentReason];
}
