import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/login_screen/login_bloc/login_event.dart';
import 'package:sfa/ui/login_screen/login_bloc/login_state.dart';
import 'package:sfa/ui/login_screen/login_model/login_response.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEvent) {
      yield* login();
    }
  }

  Stream<LoginState> login() async* {
    LoginResponse response = await repository.login({});

    if (response.success) {
    } else {}
  }
}
