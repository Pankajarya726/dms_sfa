import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/my_profile_details/my_profile_details_bloc/my_profile_details_event.dart';
import 'package:sfa/ui/my_profile_details/my_profile_details_bloc/my_profile_details_state.dart';
import 'package:sfa/ui/team_members_details_screen/model/team_members_details_model.dart';
import 'package:sfa/utility/network.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class MyProfileDetailsBloc
    extends Bloc<MyProfileDetailsEvents, MyProfileDetailsState> {
  MyProfileDetailsBloc() : super(MyProfileDetailsInitialState());
  @override
  Stream<MyProfileDetailsState> mapEventToState(
      MyProfileDetailsEvents event) async* {
    if (event is MyProfileDetailsInitialEvent) {
      yield MyProfileDetailsLoadingState();
      yield* getMyProfileData(event);
    }
    if (event is MyProfileDetailsSelectDateEvent) {
      yield MyProfileDetailsLoadingState();
      yield MyProfileDetailsSelectDateState(dateTime: event.dateTime);
    }
    if (event is MyProfileDetailsIncrementDateEvent) {
      yield MyProfileDetailsLoadingState();
      yield MyProfileDetailsIncrementDateState(dateTime: event.dateTime);
    }
    if (event is MyProfileDetailsDecrementDateEvent) {
      yield MyProfileDetailsLoadingState();
      yield MyProfileDetailsDecrementDateState(dateTime: event.dateTime);
    }
  }

  Stream<MyProfileDetailsState> getMyProfileData(
      MyProfileDetailsInitialEvent event) async* {
    if (await Network.isConnected()) {
      DateTime d = DateTime.parse(event.currentDate);
      if (d.weekday != 7) {
        String userId = await SharedPrefrence.getStringPreference("id");
        DetailsStatusResponse response =
            await repository.getTeamMembersDetails(userId, event.currentDate);

        if (response.success) {
          yield MyProfileDetailsInitialSuccessState(
              detailsStatusResponse: response);
        } else {
          yield MyProfileDetailsFailureState(failureMessage: response.message);
        }
      } else {
        yield MyProfileDetailsFailureState(failureMessage: "Weekend Off");
      }
    } else {
      yield MyProfileDetailsFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }
}
