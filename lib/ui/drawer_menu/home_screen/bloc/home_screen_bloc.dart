import 'package:dms/ui/drawer_menu/home_screen/bloc/home_screen_events.dart';
import 'package:dms/ui/drawer_menu/home_screen/bloc/home_screen_states.dart';
import 'package:dms/ui/drawer_menu/home_screen/model/user_details_response.dart';
import 'package:dms/ui/start_my_day/model/start_my_day_response.dart.dart';
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
  }

  Stream<HomeScreenStates> getUserDetails(GetUserDetailsEvent event) async* {
    if (await Network.isConnected()) {
      String userId = await SharedPreference.getStringPreference("id");

      UserDetails response = await repository.getUserDetailsByUserId(userId);

      if (response.success) {
        yield GetUserDetailsState(userDetails: response);
      } else {
        yield HomeScreenFailureState(failureMessage: response.message);
      }
    } else {
      yield HomeScreenFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }
}
