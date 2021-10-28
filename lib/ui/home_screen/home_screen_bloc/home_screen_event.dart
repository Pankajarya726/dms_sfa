import 'package:equatable/equatable.dart';

class HomeScreenEvents extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class HomeScreenEvent extends HomeScreenEvents {
  final String id;
  HomeScreenEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class HomeScreenMenuEvent extends HomeScreenEvents {
  HomeScreenMenuEvent();
  @override
  List<Object?> get props => [];
}
