import 'package:equatable/equatable.dart';

class PjpByDateEvent extends Equatable {
  final String userId;
  final String date;
  const PjpByDateEvent({required this.date, required this.userId});
  @override
  List<Object?> get props => [date, userId];
}
