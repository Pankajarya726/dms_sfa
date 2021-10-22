import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/pjp_screen/pjp_bloc/pjp_event.dart';
import 'package:sfa/ui/pjp_screen/pjp_bloc/pjp_state.dart';
import 'package:sfa/ui/pjp_screen/pjp_model/pjp_model.dart';
import 'package:sfa/ui/pjp_screen/update_pjp_model/update_pjp_model.dart';

class PjpBloc extends Bloc<PjpEvents, PjpState> {
  PjpBloc() : super(PjpInitialState());
  @override
  Stream<PjpState> mapEventToState(PjpEvents event) async* {
    if (event is PjpEvent) {
      yield PjpLoadingState();
      yield* pjpData(event);
    }
    if (event is UpdatePjpEvent) {
      yield UpdateLoadingState();
      yield* updatePjp(event);
    }
    if (event is DateIncrementEvent) {
      yield UpdateLoadingState();
      yield* incrementDate();
    }
    if (event is DateDecrementEvent) {
      yield UpdateLoadingState();
      yield* inecrementDate();
    }
  }

  Stream<PjpState> pjpData(PjpEvent event) async* {
    PjpResponse response = await repository.getPjpData(event.id, event.month);
    if (response.success) {
      yield PjpSuccessState(response: response.data!);
    } else {
      yield PjpFailureState(message: response.message);
    }
  }

  Stream<PjpState> updatePjp(UpdatePjpEvent event) async* {
    UpdateResponce responce =
        await repository.updatePjpData(event.id, event.description);
    if (responce.success) {
      yield UpdateSuccessState(response: responce);
    } else {
      yield UpdateFailureState(message: responce.message);
    }
  }

  Stream<PjpState> incrementDate() async* {
    DateTime dateTime = await NTP.now();
    var format = DateFormat("MMM-yyyy");
    yield DateIncrementState(dateTime: format.format(dateTime));
  }

  Stream<PjpState> inecrementDate() async* {
    DateTime dateTime = await NTP.now();
    var format = DateFormat("MMM-yyyy");
    yield DateDecrementState(dateTime: format.format(dateTime));
  }
}
