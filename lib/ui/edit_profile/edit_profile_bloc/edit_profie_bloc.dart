import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/edit_profile/edit_profile_bloc/edit_profile_event.dart';
import 'package:sfa/ui/edit_profile/edit_profile_bloc/edit_profile_state.dart';
import 'package:sfa/ui/edit_profile/model/edit_profile_model.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';
import 'package:sfa/utility/network.dart';

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
      EditProfileResponse response = await repository.editProfile(
          event.name, event.emailId, File(event.imgFile));
      if (response.success) {
        yield EditProfileSuccessState(response: response);
      } else {
        EditProfileFailureState(message: response.message);
      }
    } else {
      yield EditProfileNetworkState(message: "Network not connected");
    }
  }

  Stream<EditProfileState> getUserDetails(GetUserDetailsEvent event) async* {
    if (await Network.isConnected()) {
      UserDetails response =
          await repository.getUserDetailsByUserId(event.userId);
      if (response.success) {
        yield GetUserDetailsSucessState(response: response);
      } else {
        yield GetUserDetailsFailureState(message: response.message);
      }
    } else {
      yield EditProfileNetworkState(message: "Network not connected");
    }
  }
}
