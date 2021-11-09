import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/forgot_password/bloc/forgot_password_event.dart';
import 'package:sfa/ui/forgot_password/bloc/forgot_password_state.dart';
import 'package:sfa/ui/forgot_password/model/forgot_password_model.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitalState());
  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    if (event is ForgotPasswordEvent) {
      yield* forgotPassword(event);
    }
  }

  Stream<ForgotPasswordState> forgotPassword(ForgotPasswordEvent event) async* {
    ForgotPasswordResponse response = await repository.forgotPassword(
        event.mobileNo, event.password, event.confPass);
    if (response.success) {
      yield ForgotPasswordSuccessState(response: response);
    } else {
      yield ForgotPasswordFailureState(message: response.message);
    }
  }
}
