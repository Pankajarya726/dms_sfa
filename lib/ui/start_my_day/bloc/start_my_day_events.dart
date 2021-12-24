import 'package:equatable/equatable.dart';

class StartMyDayEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetQuotesAndImagesEvent extends StartMyDayEvents {
  @override
  List<Object> get props => [];
}

class StartMyDayEvent extends StartMyDayEvents {
  final Map<String, dynamic> input;

  StartMyDayEvent({
    required this.input,
  });

  @override
  List<Object> get props => [input];
}

class EndMyDayEvent extends StartMyDayEvents {
  @override
  List<Object> get props => [];
}
