import 'package:equatable/equatable.dart';
import 'package:sfa/ui/team_member_track_screen/model/track_model.dart';

class TrackState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class TrackInitialState extends TrackState {}

class TrackLoadingState extends TrackState {}

class TrackSuccessState extends TrackState {
  final TrackResponse response;
  TrackSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class TrackFailureState extends TrackState {
  final String message;
  TrackFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
