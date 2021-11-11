import 'package:equatable/equatable.dart';

class FilterEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class FilterEvent extends FilterEvents {
  final String locationType;
  FilterEvent({required this.locationType});
  @override
  List<Object?> get props => [locationType];
}
