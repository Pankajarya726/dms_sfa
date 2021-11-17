import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/login_screen/login_bloc/login_event.dart';
import 'package:sfa/ui/login_screen/login_bloc/login_state.dart';
import 'package:sfa/ui/login_screen/login_model/login_response.dart';
import 'package:sfa/utility/network.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEvent) {
      yield LoginLoadingState();
      yield* login(event);
    }
  }

  Stream<LoginState> login(LoginEvent event) async* {
    if (await Network.isConnected()) {
      LoginResponse response =
          await repository.login(event.mobileNumber, event.password);
      if (response.success) {
        SharedPrefrence.setStringPreference(
            SharedPrefrence.token, response.accessToken);
        options.headers.addAll({
          "Authorization": "Bearer ${response.accessToken}",
        });
        yield LoginSuccessState(loginResponse: response);
      } else {
        yield LoginFailureState(message: response.message);
      }
    } else {
      yield LoginFailureState(
          message: "Please check your internet connection!");
    }
  }
}
