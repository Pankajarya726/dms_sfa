import 'package:dms/main.dart';
import 'package:dms/ui/drawer_menu/home_screen/model/user_details_response.dart';
import 'package:dms/ui/login_screen/login_bloc/login_event.dart';
import 'package:dms/ui/login_screen/login_bloc/login_state.dart';
import 'package:dms/ui/login_screen/login_model/login_response.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginBloc extends Bloc<LoginEvents, LoginState> {
  LoginBloc() : super(LoginInitialState());

  @override
  Stream<LoginState> mapEventToState(LoginEvents event) async* {
    if (event is LoginEvent) {
      yield LoginLoadingState();
      yield* login(event);
    }
    if (event is GetUserEvent) {
      yield LoginLoadingState();
      yield* getUserDetails(event);
    }
  }

  Stream<LoginState> login(LoginEvent event) async* {
    if (await Network.isConnected()) {
      EasyLoading.show();
      LoginResponse response = await repository.login(event.mobileNumber, event.password);
      EasyLoading.dismiss();
      if (response.success) {
        SharedPreference.setStringPreference(SharedPreference.accessToken, response.accessToken);
        options.headers.addAll({
          "Authorization": "Bearer ${response.accessToken}",
        });
        yield LoginSuccessState(loginResponse: response);
      } else {
        yield LoginFailureState(message: response.message);
      }
    } else {
      yield LoginFailureState(message: "Please check your internet connection!");
    }
  }

  Stream<LoginState> getUserDetails(GetUserEvent event) async* {
    if (await Network.isConnected()) {
      String userId = await SharedPreference.getStringPreference(SharedPreference.userId);

      GetUserResponse response = await repository.getUserDetailsByUserId(userId);

      if (response.success) {
        yield GetUserDetailsState(userDetails: response);
      } else {
        yield LoginFailureState(message: response.message);
      }
    } else {
      yield LoginFailureState(message: "Please check your internet connection!");
    }
  }
}
