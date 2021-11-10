import 'package:equatable/equatable.dart';

class PjpByDateEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class PjpByDateEvent extends PjpByDateEvents {
  final String userId;
  final String date;
  PjpByDateEvent({required this.date, required this.userId});
  @override
  List<Object?> get props => [date, userId];
}
