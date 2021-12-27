import 'package:dms/ui/drawer_menu/home_screen/model/user_details_response.dart';
import 'package:dms/ui/edit_profile/model/update_profile_response.dart';
import 'package:dms/ui/settings_screen/settings_bloc/settings_event.dart';
import 'package:dms/ui/settings_screen/settings_bloc/settings_state.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';

class SettingsBloc extends Bloc<SettingEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitialState());

  @override
  Stream<SettingsState> mapEventToState(SettingEvent event) async* {
    if (event is GetSettingEvent) {
      yield* loadUserDetails(event);
    }
  }

  Stream<SettingsState> loadUserDetails(GetSettingEvent event) async* {
    if (event.userId.isNotEmpty) {
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
          id: int.parse(event.userId),
          name: Constants.name,
          email: Constants.email,
          profilePicture: Constants.image,
          mobileNumber: Constants.mobile);

      yield GetUserDetailsSuccessState(user: user);
    } else {
      if (await Network.isConnected()) {
        GetUserResponse response = await repository.getUserDetailsByUserId(event.userId);
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
              id: int.parse(event.userId),
              name: Constants.name,
              email: Constants.email,
              profilePicture: Constants.image,
              mobileNumber: Constants.mobile);
          yield GetUserDetailsSuccessState(user: user);
        } else {
          yield DetailsFailureState(message: response.message);
        }
      }
    }
  }
}
