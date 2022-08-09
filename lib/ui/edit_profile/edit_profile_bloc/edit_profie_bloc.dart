import 'package:dms/ui/drawer_menu/home_screen/model/user_details_response.dart';
import 'package:dms/ui/edit_profile/edit_profile_bloc/edit_profile_state.dart';
import 'package:dms/ui/edit_profile/model/update_profile_response.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      yield* getUserDetails();
    }
  }

  Stream<EditProfileState> editProfile(EditProfileEvent event) async* {
    if (await Network.isConnected()) {
      Utility.showLoading();
      UpdateProfileResponse response = await repository.editProfile(event.name, event.emailId, event.imgFile);
      Utility.dismissLoading();
      if (response.success) {
        await SharedPreference.setStringPreference(SharedPreference.name, event.name);
        await SharedPreference.setStringPreference(SharedPreference.email, event.emailId);
        await SharedPreference.setStringPreference(SharedPreference.userImage, response.data!.profilePicture);

        Constants.name = event.name;
        Constants.email = event.emailId;
        Constants.image = response.data!.profilePicture;

        Utility.showToast(response.message);
        yield EditProfileSuccessState(user: response.data!);
      } else {
        EditProfileFailureState(message: response.message);
      }
    } else {
      yield EditProfileNetworkState(message: "Please check your internet connection!");
    }
  }

  Stream<EditProfileState> getUserDetails() async* {
    var userId = await SharedPreference.getStringPreference(SharedPreference.userId);

    if (userId.isNotEmpty) {
      Constants.name = await SharedPreference.getStringPreference(
        SharedPreference.name,
      );
      Constants.email = await SharedPreference.getStringPreference(
        SharedPreference.email,
      );
      Constants.image = await SharedPreference.getStringPreference(
        SharedPreference.userImage,
      );
      Constants.mobile = await SharedPreference.getStringPreference(
        SharedPreference.mobileNumber,
      );

      User user = User(
          id: int.parse(userId),
          name: Constants.name,
          email: Constants.email,
          profilePicture: Constants.image,
          mobileNumber: Constants.mobile);

      yield GetUserDetailsSuccessState(user: user);
    } else {
      if (await Network.isConnected()) {
        GetUserResponse response = await repository.getUserDetailsByUserId(userId);
        if (response.success) {
          await SharedPreference.setStringPreference(SharedPreference.name, response.data!.name);
          await SharedPreference.setStringPreference(SharedPreference.email, response.data!.email);
          await SharedPreference.setStringPreference(SharedPreference.userImage, response.data!.image);
          await SharedPreference.setStringPreference(SharedPreference.mobileNumber, response.data!.mobileNumber);
          Constants.name = response.data!.name;
          Constants.email = response.data!.email;
          Constants.image = response.data!.image;
          Constants.mobile = response.data!.mobileNumber;

          User user = User(
              id: int.parse(userId),
              name: Constants.name,
              email: Constants.email,
              profilePicture: Constants.image,
              mobileNumber: Constants.mobile);

          yield GetUserDetailsSuccessState(user: user);
        } else {
          yield GetUserDetailsFailureState(message: response.message);
        }
      } else {
        yield EditProfileNetworkState(message: "Please check your internet connection!");
      }
    }
  }
}
