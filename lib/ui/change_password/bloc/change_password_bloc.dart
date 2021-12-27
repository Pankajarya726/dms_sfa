import 'package:dms/ui/change_password/model/model.dart';
import 'package:dms/utils/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../main.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInitialState());
  @override
  Stream<ChangePasswordState> mapEventToState(
      ChangePasswordEvent event) async* {
    if (event is ChangePasswordEvent) {
      yield ChangePasswordLoadingState();
      yield* changePass(event);
    }
  }

  Stream<ChangePasswordState> changePass(ChangePasswordEvent event) async* {
    if (await Network.isConnected()) {
      EasyLoading.show();
      ChangePassResponse response = await repository.changePassword(event.id,
          event.currentPassword, event.newPassword, event.confPassword);
      EasyLoading.dismiss();
      if (response.success) {
        yield ChangePasswordSuccessState(response: response);
      } else {
        yield ChangePasswordFailureState(message: response.message);
      }
    } else {
      yield ChangePasswordFailureState(
          message: "Please check your internet connection first!");
    }
  }
}
