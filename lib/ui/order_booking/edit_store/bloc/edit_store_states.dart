import 'package:dms/ui/order_booking/edit_store/model/editstore_getenroll_type_response.dart';
import 'package:dms/ui/order_booking/edit_store/model/select_language_response.dart';
import 'package:dms/ui/order_booking/edit_store/model/select_retailer_category_response.dart';
import 'package:dms/ui/order_booking/edit_store/model/select_retailer_type_response.dart';
import 'package:equatable/equatable.dart';

class EditStoreStates extends Equatable {
  @override
  List<Object> get props => [];
}

class EditStoreInitialState extends EditStoreStates {}

class EditStoreILoadingState extends EditStoreStates {}

class GetEnrolmentTypeState extends EditStoreStates {
  final GetEnrollTypeResponse getEnrollTypeResponse;
  GetEnrolmentTypeState({required this.getEnrollTypeResponse});
  @override
  List<Object> get props => [getEnrollTypeResponse];
}

class EditStoreFailureState extends EditStoreStates {
  final String failureMessage;
  EditStoreFailureState({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}

class SelectLanguageTypeState extends EditStoreStates {
  final SelectLanguageResponse selectLanguageResponse;
  SelectLanguageTypeState({required this.selectLanguageResponse});
  @override
  List<Object> get props => [selectLanguageResponse];
}

class SelectRetailerTypeState extends EditStoreStates {
  final SelectRetailerTypeResponse selectRetailerTypeResponse;
  SelectRetailerTypeState({required this.selectRetailerTypeResponse});
  @override
  List<Object> get props => [selectRetailerTypeResponse];
}

class SelectRetailerCategoryState extends EditStoreStates {
  final SelectRetailerCategoryResponse selectRetailerCategoryResponse;
  SelectRetailerCategoryState({required this.selectRetailerCategoryResponse});
  @override
  List<Object> get props => [selectRetailerCategoryResponse];
}
