import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_event.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_state.dart';
import 'package:sfa/ui/pjp_by_date/model/pjp_by_date_model.dart';

class PjpByDateBloc extends Bloc<PjpByDateEvent, PjpByDateState> {
  PjpByDateBloc() : super(PjpByDateInitialState());
  @override
  Stream<PjpByDateState> mapEventToState(PjpByDateEvent event) async* {
    if (event is PjpByDateEvent) {
      yield PjpByDateLoadingState();
      yield* getPjpData(event);
    }
  }

  Stream<PjpByDateState> getPjpData(PjpByDateEvent event) async* {
    PjpByDateResponse response =
        await repository.pjpByDate(event.userId, event.date);

    if (response.success) {
      log(response.data.toString());
      yield PjpByDateSuccessState(response: response);
    } else {
      yield PjpByDateFailureState(message: response.message);
    }
  }
}
