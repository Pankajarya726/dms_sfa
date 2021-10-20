import 'package:equatable/equatable.dart';
import 'package:sfa/ui/add_pjp_screen/add_pjp_model/add_pjp_model.dart';

class AddPJPState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class AddPJPInitialState extends AddPJPState {}

class AddPJPLoadingState extends AddPJPState {}

class AddPJPSuccessState extends AddPJPState {
  final AddPjpResponse response;
  AddPJPSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class AddPJPFailureState extends AddPJPState {
  final String messages;
  AddPJPFailureState({required this.messages});
}
