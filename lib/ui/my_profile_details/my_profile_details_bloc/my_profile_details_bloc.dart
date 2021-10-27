import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/ui/my_profile_details/my_profile_details_bloc/my_profile_details_event.dart';
import 'package:sfa/ui/my_profile_details/my_profile_details_bloc/my_profile_details_state.dart';

class MyProfileDetailsBloc
    extends Bloc<MyProfileDetailsEvents, MyProfileDetailsState> {
  MyProfileDetailsBloc() : super(MyProfileDetailsInitialState());
  @override
  Stream<MyProfileDetailsState> mapEventToState(
      MyProfileDetailsEvents event) async* {
    if (event is MyProfileDetailsSelectDateEvent) {
      yield MyProfileDetailsSelectDateState(dateTime: event.dateTime);
    }
    if (event is MyProfileDetailsIncrementDateEvent) {
      yield MyProfileDetailsIncrementDateState(dateTime: event.dateTime);
    }
    if (event is MyProfileDetailsDecrementDateEvent) {
      yield MyProfileDetailsDecrementDateState(dateTime: event.dateTime);
    }
  }
}
