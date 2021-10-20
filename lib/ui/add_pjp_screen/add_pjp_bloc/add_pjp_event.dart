import 'package:equatable/equatable.dart';

class AddPJPEvent extends Equatable {
  final String id;
  final String date;
  final String description;
  const AddPJPEvent(
      {required this.id, required this.date, required this.description});
  @override
  List<Object?> get props => [id, date, description];
}
