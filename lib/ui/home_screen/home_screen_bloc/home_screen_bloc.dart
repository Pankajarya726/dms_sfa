import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/home_screen/home_screen_bloc/home_screen_event.dart';
import 'package:sfa/ui/home_screen/home_screen_bloc/home_screen_state.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(HomeScreenInitialState());

  @override
  Stream<HomeScreenState> mapEventToState(HomeScreenEvent event) async* {
    if (event is HomeScreenEvent) {
      yield HomeScreenLoadingState();
      yield* getUserDetails(event);
    }
  }

  Stream<HomeScreenState> getUserDetails(HomeScreenEvent event) async* {
    UserData response = await repository.getUserDetailsByUserId(event.id);
    if (response.success) {
      yield HomeScreenSuccessState(userData: response);
    } else {
      yield HomeScreenFailureState(messages: response.message);
    }
  }
}
