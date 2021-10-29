import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/change_password/bloc/change_password_event.dart';
import 'package:sfa/ui/change_password/bloc/change_password_state.dart';
import 'package:sfa/ui/change_password/model/model.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInitialState());
  @override
  Stream<ChangePasswordState> mapEventToState(
      ChangePasswordEvent event) async* {
    if (event is ChangePasswordEvent) {
      yield* changePass(event);
    }
  }

  Stream<ChangePasswordState> changePass(ChangePasswordEvent event) async* {
    ChangePassResponse response = await repository.changePassword(
        event.id, event.currentPassword, event.newPassword, event.confPassword);
    if (response.success) {
      yield ChangePasswordSuccessState(response: response);
    } else {
      yield ChangePasswordFailureState(message: response.message);
    }
  }
}
