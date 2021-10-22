import 'package:equatable/equatable.dart';

class PjpEvents extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class PjpEvent extends PjpEvents {
  final String id;
  final String month;
  PjpEvent({required this.id, required this.month});
  @override
  List<Object?> get props => [id, month];
}

class UpdatePjpEvent extends PjpEvents {
  final String id;
  final String description;
  UpdatePjpEvent({required this.id, required this.description});
  @override
  List<Object?> get props => [id, description];
}

class DateIncrementEvent extends PjpEvents {}

class DateDecrementEvent extends PjpEvents {}
