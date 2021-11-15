import 'package:equatable/equatable.dart';
import 'package:sfa/ui/report_screen/model/report_model.dart';

class ReportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReportInitialState extends ReportState {}

class ReportLoadingState extends ReportState {}

class ReportSuccessState extends ReportState {
  final ReportResponse response;
  ReportSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class ReportFailureState extends ReportState {
  final String message;
  ReportFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}

class ReportNetworkState extends ReportState {
  final String message;
  ReportNetworkState({required this.message});
  @override
  List<Object?> get props => [message];
}
