import 'package:dio/dio.dart';
import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/edit_store/bloc/edit_store_events.dart';
import 'package:dms/ui/order_booking/edit_store/bloc/edit_store_states.dart';
import 'package:dms/ui/order_booking/edit_store/model/editstore_getenroll_type_response.dart';
import 'package:dms/ui/order_booking/edit_store/model/select_language_response.dart';
import 'package:dms/ui/order_booking/edit_store/model/select_retailer_category_response.dart';
import 'package:dms/ui/order_booking/edit_store/model/select_retailer_type_response.dart';
import 'package:dms/utils/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditStoreBloc extends Bloc<EditStoreEvents, EditStoreStates> {
  EditStoreBloc() : super(EditStoreInitialState());

  @override
  Stream<EditStoreStates> mapEventToState(EditStoreEvents event) async* {
    if (event is GetEnrolmentTypeEvent) {
      yield EditStoreILoadingState();
      yield* getEnrolmentType(event);
    }
    if (event is SelectLanguageTypeEvent) {
      yield EditStoreILoadingState();
      yield* selectLanguage(event);
    }
    if (event is SelectRetailerTypeEvent) {
      yield EditStoreILoadingState();
      yield* selectRetailerType(event);
    }
    if (event is SelectRetailerCategoryEvent) {
      yield EditStoreILoadingState();
      yield* selectRetailerCategory(event);
    }
  }

  Stream<EditStoreStates> getEnrolmentType(GetEnrolmentTypeEvent event) async* {
    if (await Network.isConnected()) {
      GetEnrollTypeResponse response = await repository.getEnrolmentType();
      if (response.success) {
        yield GetEnrolmentTypeState(getEnrollTypeResponse: response);
      } else {
        yield EditStoreFailureState(failureMessage: response.message);
      }
    } else {
      yield EditStoreFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }

  Stream<EditStoreStates> selectLanguage(SelectLanguageTypeEvent event) async* {
    if (await Network.isConnected()) {
      SelectLanguageResponse response = await repository.selectLanguage();
      if (response.success) {
        yield SelectLanguageTypeState(selectLanguageResponse: response);
      } else {
        yield EditStoreFailureState(failureMessage: response.message);
      }
    } else {
      yield EditStoreFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }

  Stream<EditStoreStates> selectRetailerType(
      SelectRetailerTypeEvent event) async* {
    if (await Network.isConnected()) {
      SelectRetailerTypeResponse response =
          await repository.selectRetailerType();
      if (response.success) {
        yield SelectRetailerTypeState(selectRetailerTypeResponse: response);
      } else {
        yield EditStoreFailureState(failureMessage: response.message);
      }
    } else {
      yield EditStoreFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }

  Stream<EditStoreStates> selectRetailerCategory(
      SelectRetailerCategoryEvent event) async* {
    if (await Network.isConnected()) {
      SelectRetailerCategoryResponse response =
          await repository.selectRetailerCategory();
      if (response.success) {
        yield SelectRetailerCategoryState(
            selectRetailerCategoryResponse: response);
      } else {
        yield EditStoreFailureState(failureMessage: response.message);
      }
    } else {
      yield EditStoreFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }
}
