import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';
import 'package:sfa/ui/settings_screen/settings_bloc/settings_event.dart';
import 'package:sfa/ui/settings_screen/settings_bloc/settings_state.dart';

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
