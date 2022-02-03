import 'package:dms/ui/drawer_menu/home_screen/bloc/home_screen_events.dart';
import 'package:dms/ui/drawer_menu/home_screen/bloc/home_screen_states.dart';
import 'package:dms/ui/drawer_menu/home_screen/model/get_menus_response.dart';
import 'package:dms/ui/drawer_menu/home_screen/model/user_details_response.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvents, HomeScreenStates> {
  HomeScreenBloc() : super(HomeScreenInitialState());

  @override
  Stream<HomeScreenStates> mapEventToState(HomeScreenEvents event) async* {
    if (event is GetUserDetailsEvent) {
      yield HomeScreenlodaingState();
      yield* getUserDetails(event);
    }
    if (event is GetMenusEvent) {
      // yield HomeScreenlodaingState();
      yield* getMenus(event);
    }
  }

  Stream<HomeScreenStates> getUserDetails(GetUserDetailsEvent event) async* {
    var userId = await SharedPreference.getStringPreference(SharedPreference.userId);

    if (await Network.isConnected()) {
      GetUserResponse response = await repository.getUserDetailsByUserId(userId);
      if (response.success) {
        await SharedPreference.setStringPreference(SharedPreference.name, response.data!.name);
        await SharedPreference.setStringPreference(SharedPreference.email, response.data!.email);
        await SharedPreference.setStringPreference(SharedPreference.userImage, response.data!.image);
        await SharedPreference.setStringPreference(SharedPreference.mobileNumber, response.data!.mobileNumber);
        await SharedPreference.setStringPreference(SharedPreference.mobileNumber, response.data!.designation);
        Constants.name = response.data!.name;
        Constants.email = response.data!.email;
        Constants.image = response.data!.image;
        Constants.mobile = response.data!.mobileNumber;
        Constants.designation = response.data!.designation;

        UserDetails user = UserDetails(
            id: int.parse(userId),
            name: Constants.name,
            email: Constants.email,
            image: Constants.image,
            mobileNumber: Constants.mobile,
            clockInOutData: [],
            startMyDay: '',
            pjpDescription: '',
            pjpButton: '',
            designation: Constants.designation);

        yield GetUserDetailsSuccessState(userDetails: user);
      } else {
        yield HomeScreenFailureState(failureMessage: response.message);
      }
    } else {
      yield HomeScreenFailureState(failureMessage: "Please check your internet connection!");
    }
  }

  Stream<HomeScreenStates> getMenus(GetMenusEvent event) async* {
    if (await Network.isConnected()) {
      GetMenusResponse response = await repository.getMenus();

      if (response.success) {
        yield GetMenusState(menu: response.data!);
      } else {
        yield HomeScreenFailureState(failureMessage: response.message);
      }
    } else {
      yield HomeScreenFailureState(failureMessage: "Please check your internet connection!");
    }
  }
}
