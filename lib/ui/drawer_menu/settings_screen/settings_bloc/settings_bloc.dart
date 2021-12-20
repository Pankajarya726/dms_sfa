import 'dart:math';

import 'package:dms/ui/drawer_menu/home_screen/model/user_details_response.dart';
import 'package:dms/ui/drawer_menu/settings_screen/settings_bloc/settings_event.dart';
import 'package:dms/ui/drawer_menu/settings_screen/settings_bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitialState());
  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is SettingsEvent) {
      yield* loadUserDetails(event);
    }
  }

  Stream<SettingsState> loadUserDetails(SettingsEvent event) async* {
    UserDetails response =
        await repository.getUserDetailsByUserId(event.userId);
    if (response.success) {
      yield DetailsSucessState(response: response);
    } else {
      yield DetailsFailureState(message: response.message);
    }
  }
}
