import 'package:equatable/equatable.dart';

class TrackEvent extends Equatable {
  final String id;
  final String date;
  const TrackEvent({required this.id, required this.date});
  @override
  List<Object?> get props => [id, date];
}
