import 'package:dms/main.dart';
import 'package:dms/ui/add_store/bloc/edit_store_events.dart';
import 'package:dms/ui/add_store/bloc/edit_store_states.dart';
import 'package:dms/ui/add_store/model/call_time_slot_response.dart';
import 'package:dms/ui/add_store/model/editstore_getenroll_type_response.dart';
import 'package:dms/ui/add_store/model/select_distributor_response.dart';
import 'package:dms/ui/add_store/model/select_district_response.dart';
import 'package:dms/ui/add_store/model/select_language_response.dart';
import 'package:dms/ui/add_store/model/select_retailer_category_response.dart';
import 'package:dms/ui/add_store/model/select_retailer_type_response.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
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
    if (event is SelectDistrictEvent) {
      yield EditStoreILoadingState();
      yield* selectDistrict(event);
    }
    if (event is SelectDistributorEvent) {
      yield EditStoreILoadingState();
      yield* selectDistributor(event);
    }
    if (event is SelectCallTimeSlotEvent) {
      yield EditStoreILoadingState();
      yield* selectCallTimeSlot(event);
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
      yield EditStoreFailureState(failureMessage: internetCheck);
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
      yield EditStoreFailureState(failureMessage: internetCheck);
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
      yield EditStoreFailureState(failureMessage: internetCheck);
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
      yield EditStoreFailureState(failureMessage: internetCheck);
    }
  }

  Stream<EditStoreStates> selectDistrict(SelectDistrictEvent event) async* {
    if (await Network.isConnected()) {
      SelectDistrictResponse response = await repository.selectDistrict();
      if (response.success) {
        yield SelectDistrictState(selectDistrictResponse: response);
      } else {
        yield EditStoreFailureState(failureMessage: response.message);
      }
    } else {
      yield EditStoreFailureState(failureMessage: internetCheck);
    }
  }

  Stream<EditStoreStates> selectDistributor(
      SelectDistributorEvent event) async* {
    if (await Network.isConnected()) {
      SelectDistributorResponse response =
          await repository.selectDistributor(event.districtId);
      if (response.success) {
        yield SelectDistributorState(selectDistributorResponse: response);
      } else {
        yield EditStoreFailureState(failureMessage: response.message);
      }
    } else {
      yield EditStoreFailureState(failureMessage: internetCheck);
    }
  }

  Stream<EditStoreStates> selectCallTimeSlot(
      SelectCallTimeSlotEvent event) async* {
    if (await Network.isConnected()) {
      CallTimeSlotResponse response = await repository.selectCallTimeslot();
      if (response.success) {
        yield SelectCallTimeSlotState(callTimeSlotResponse: response);
      } else {
        yield EditStoreFailureState(failureMessage: response.message);
      }
    } else {
      yield EditStoreFailureState(failureMessage: internetCheck);
    }
  }
}
