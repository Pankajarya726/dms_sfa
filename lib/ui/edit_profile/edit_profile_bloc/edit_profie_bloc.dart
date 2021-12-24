import 'dart:developer';

import 'package:dms/ui/drawer_menu/home_screen/model/user_details_response.dart';
import 'package:dms/ui/edit_profile/edit_profile_bloc/edit_profile_state.dart';
import 'package:dms/ui/edit_profile/model/edit_profile_model.dart';
import 'package:dms/utils/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../main.dart';
import 'edit_profile_event.dart';

class EditProfileBloc extends Bloc<EditProfileEvents, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitialState());

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvents event) async* {
    if (event is EditProfileEvent) {
      yield* editProfile(event);
    }
    if (event is GetUserDetailsEvent) {
      yield EditProfileLoadingState();
      yield* getUserDetails(event);
    }
  }

  Stream<EditProfileState> editProfile(EditProfileEvent event) async* {
    if (await Network.isConnected()) {
      log("msg");
      EasyLoading.show();
      EditProfileResponse response = await repository.editProfile(event.name, event.emailId, event.imgFile);
      EasyLoading.dismiss();
      if (response.success) {
        yield EditProfileSuccessState(response: response);
      } else {
        EditProfileFailureState(message: response.message);
      }
    } else {
      yield EditProfileNetworkState(message: "Please check your internet connection!");
    }
  }

  Stream<EditProfileState> getUserDetails(GetUserDetailsEvent event) async* {
    if (await Network.isConnected()) {
      UserDetails response = await repository.getUserDetailsByUserId(event.userId);
      if (response.success) {
        yield GetUserDetailsSucessState(response: response);
      } else {
        yield GetUserDetailsFailureState(message: response.message);
      }
    } else {
      yield EditProfileNetworkState(message: "Please check your internet connection!");
    }
  }
}
