import 'package:dms/ui/start_my_day/model/end_my_day_response.dart';
import 'package:dms/ui/start_my_day/model/quotes_and_images_response.dart';
import 'package:equatable/equatable.dart';

class StartMyDayStates extends Equatable {
  @override
  List<Object> get props => [];
}

class StartMyDayInitialState extends StartMyDayStates {}

class StartMyDayLoadingState extends StartMyDayStates {}

class StartMyDaySuccessState extends StartMyDayStates {
  final String successMessage;
  StartMyDaySuccessState({required this.successMessage});
  @override
  List<Object> get props => [successMessage];
}

class StartMyDayFailureState extends StartMyDayStates {
  final String failureMessage;
  StartMyDayFailureState({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}

class GetQuotesAndImagesState extends StartMyDayStates {
  final QuotesAndImagesResponse quotesAndImagesResponse;
  final String currentDate;
  GetQuotesAndImagesState({required this.quotesAndImagesResponse, required this.currentDate});
  @override
  List<Object> get props => [quotesAndImagesResponse, currentDate];
}

class EndMyDaySuccessState extends StartMyDayStates {
  final EndMyDayResponse endMyDayResponse;
  EndMyDaySuccessState({required this.endMyDayResponse});
  @override
  List<Object> get props => [endMyDayResponse];
}

class EndMyDayFailureState extends StartMyDayStates {
  final String failureMessage;

  EndMyDayFailureState({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}
