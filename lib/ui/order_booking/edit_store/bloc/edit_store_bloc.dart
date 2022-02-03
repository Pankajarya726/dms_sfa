import 'package:dio/dio.dart';
import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/edit_store/bloc/edit_store_events.dart';
import 'package:dms/ui/order_booking/edit_store/bloc/edit_store_states.dart';
import 'package:dms/ui/order_booking/edit_store/model/editstore_getenroll_type_response.dart';
import 'package:dms/utils/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditStoreBloc extends Bloc<EditStoreEvents, EditStoreStates> {
  EditStoreBloc() : super(EditStoreInitialState());

  @override
  Stream<EditStoreStates> mapEventToState(EditStoreEvents event) async* {
    if (event is EditStoreGetEnrolmentTypeEvent) {
      yield* getEnrolmentType(event);
    }
  }

  Stream<EditStoreStates> getEnrolmentType(
      EditStoreGetEnrolmentTypeEvent event) async* {
    if (await Network.isConnected()) {
      EditStoreGetEnrollTypeResponse response =
          await repository.getEnrolmentType();
      if (response.success) {
        yield EditStoreGetEnrolmentTypeState(
            editStoreGetEnrollTypeResponse: response);
      } else {
        yield EditStoreFailureState(failureMessage: response.message);
      }
    } else {
      yield EditStoreFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }
}
