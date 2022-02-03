import 'package:dms/ui/order_booking/edit_store/model/editstore_getenroll_type_response.dart';
import 'package:equatable/equatable.dart';

class EditStoreStates extends Equatable {
  @override
  List<Object> get props => [];
}

class EditStoreInitialState extends EditStoreStates {}

class EditStoreILoadingState extends EditStoreStates {}

class EditStoreGetEnrolmentTypeState extends EditStoreStates {
  final EditStoreGetEnrollTypeResponse editStoreGetEnrollTypeResponse;
  EditStoreGetEnrolmentTypeState(
      {required this.editStoreGetEnrollTypeResponse});
  @override
  List<Object> get props => [editStoreGetEnrollTypeResponse];
}

class EditStoreFailureState extends EditStoreStates {
  final String failureMessage;
  EditStoreFailureState({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}
