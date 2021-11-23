import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/team%20members_status/bloc/get_all_users_status_events.dart';
import 'package:sfa/ui/team%20members_status/bloc/get_all_users_status_states.dart';
import 'package:sfa/ui/team%20members_status/model/get_all_users_status.dart';
import 'package:sfa/utility/network.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class GetAllUserStatusBloc
    extends Bloc<GetAllUserStatusEvents, GetAllUserStatusStates> {
  GetAllUserStatusBloc() : super(GetAllUserStatusInitialState());

  @override
  Stream<GetAllUserStatusStates> mapEventToState(
      GetAllUserStatusEvents event) async* {
    if (event is GetAllUserStatusInitialEvent) {
      yield GetAllUserStatusLoadingState();
      yield* getAllUsersStatus(event);
    }
  }

  Stream<GetAllUserStatusStates> getAllUsersStatus(
      GetAllUserStatusInitialEvent event) async* {
    if (await Network.isConnected()) {
      DateTime d = DateTime.parse(event.statusDate);
      if (d.weekday != 7) {
        String userId = await SharedPrefrence.getStringPreference("id");
        GetAllUsersStatusResponse response = await repository.getAllUsersStatus(
            userId,
            event.statusDate,
            event.filterName,
            event.locationType,
            event.location);
        if (response.success) {
          List<AttendanceStatusModel> statusList = [];

          if (response.data!.clockInAppr.isNotEmpty) {
            for (var element in response.data!.clockInAppr) {
              statusList.add(AttendanceStatusModel(
                  approveStatus: 1,
                  status: "Present",
                  userId: element.userId,
                  userName: element.name));
            }
          }
          if (response.data!.clockInReject.isNotEmpty) {
            for (var element in response.data!.clockInReject) {
              statusList.add(AttendanceStatusModel(
                  approveStatus: 0,
                  status: "Present",
                  userId: element.userId,
                  userName: element.name));
            }
          }
          if (response.data!.absentApproved.isNotEmpty) {
            for (var element in response.data!.absentApproved) {
              statusList.add(AttendanceStatusModel(
                  approveStatus: 1,
                  status: "Absent",
                  userId: element.userId,
                  userName: element.name));
            }
          }
          if (response.data!.absentReject.isNotEmpty) {
            for (var element in response.data!.absentReject) {
              statusList.add(AttendanceStatusModel(
                  approveStatus: 0,
                  status: "Absent",
                  userId: element.userId,
                  userName: element.name));
            }
          }

          yield GetAllUserStatusInitialSuccessState(statusList: statusList);
        } else {
          yield GetAllUserStatusFailureState(failureMessage: response.message);
        }
      } else {
        yield GetAllUserStatusFailureState(failureMessage: "Weekend Off");
      }
    } else {
      yield GetAllUserStatusFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }
}
