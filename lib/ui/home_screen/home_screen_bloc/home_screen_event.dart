import 'package:equatable/equatable.dart';

class HomeScreenEvent extends Equatable {
  final String id;
  const HomeScreenEvent({required this.id});
  @override
  List<Object?> get props => [id];
}
