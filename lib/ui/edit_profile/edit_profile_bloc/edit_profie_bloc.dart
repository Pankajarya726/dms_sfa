import 'package:dms/ui/drawer_menu/home_screen/model/user_details_response.dart';
import 'package:dms/ui/edit_profile/edit_profile_bloc/edit_profile_state.dart';
import 'package:dms/ui/edit_profile/model/update_profile_response.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      EasyLoading.show();
      UpdateProfileResponse response = await repository.editProfile(
          event.name, event.emailId, event.imgFile);
      EasyLoading.dismiss();
      if (response.success) {
        await SharedPreference.setStringPreference(
            SharedPreference.name, response.data!.name);
        await SharedPreference.setStringPreference(
            SharedPreference.email, response.data!.email);
        await SharedPreference.setStringPreference(
            SharedPreference.userImage, response.data!.profilePicture);
        await SharedPreference.setStringPreference(
            SharedPreference.mobileNumber, response.data!.mobileNumber);
        Constants.name = response.data!.name;
        Constants.email = response.data!.email;
        Constants.image = response.data!.profilePicture;
        Constants.mobile = response.data!.mobileNumber;
        Fluttertoast.showToast(msg: response.message);
        yield EditProfileSuccessState(user: response.data!);
      } else {
        EditProfileFailureState(message: response.message);
      }
    } else {
      yield EditProfileNetworkState(
          message: "Please check your internet connection!");
    }
  }

  Stream<EditProfileState> getUserDetails() async* {
    var userId =
        await SharedPreference.getStringPreference(SharedPreference.userId);

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
        GetUserResponse response =
            await repository.getUserDetailsByUserId(userId);
        if (response.success) {
          await SharedPreference.setStringPreference(
              SharedPreference.name, response.data!.name);
          await SharedPreference.setStringPreference(
              SharedPreference.email, response.data!.email);
          await SharedPreference.setStringPreference(
              SharedPreference.userImage, response.data!.image);
          await SharedPreference.setStringPreference(
              SharedPreference.mobileNumber, response.data!.mobileNumber);
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
        yield EditProfileNetworkState(
            message: "Please check your internet connection!");
      }
    }
  }
}
