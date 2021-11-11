import 'package:equatable/equatable.dart';
import 'package:sfa/ui/bottom_sheet/filter_model/filter_model.dart';

class FilterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FilterInitialState extends FilterState {}

class FilterLoadingState extends FilterState {}

class FilterSuccessState extends FilterState {
  final FiltersResponse response;
  FilterSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class FilterFailureState extends FilterState {
  final String message;
  FilterFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
