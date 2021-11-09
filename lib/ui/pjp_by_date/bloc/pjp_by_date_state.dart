import 'package:equatable/equatable.dart';
import 'package:sfa/ui/pjp_by_date/model/pjp_by_date_model.dart';

class PjpByDateState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class PjpByDateInitialState extends PjpByDateState {}

class PjpByDateLoadingState extends PjpByDateState {}

class PjpByDateFailureState extends PjpByDateState {
  final String message;
  PjpByDateFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}

class PjpByDateSuccessState extends PjpByDateState {
  final PjpByDateResponse response;
  PjpByDateSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}
