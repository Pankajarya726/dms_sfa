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

class DateSelectEvent extends PjpEvents {
  final DateTime dateTime;
  DateSelectEvent({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class DateIncrementEvent extends PjpEvents {
  final DateTime dateTime;
  DateIncrementEvent({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class DateDecrementEvent extends PjpEvents {
  final DateTime dateTime;
  DateDecrementEvent({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}
