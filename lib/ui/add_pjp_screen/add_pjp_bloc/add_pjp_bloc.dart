import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/add_pjp_screen/add_pjp_bloc/add_pjp_event.dart';
import 'package:sfa/ui/add_pjp_screen/add_pjp_bloc/add_pjp_state.dart';
import 'package:sfa/ui/add_pjp_screen/add_pjp_model/add_pjp_model.dart';
import 'package:sfa/utility/network.dart';

class AddPJPBloc extends Bloc<AddPJPEvent, AddPJPState> {
  AddPJPBloc() : super(AddPJPInitialState());
  @override
  Stream<AddPJPState> mapEventToState(AddPJPEvent event) async* {
    if (event is AddPJPEvent) {
      yield AddPJPLoadingState();
      yield* addPjp(event);
    }
  }

  Stream<AddPJPState> addPjp(AddPJPEvent event) async* {
    if (await Network.isConnected()) {
      AddPjpResponse response =
          await repository.addPjp(event.id, event.date, event.description);
      if (response.success) {
        yield AddPJPSuccessState(response: response);
      } else {
        yield AddPJPFailureState(messages: response.message);
      }
    } else {
      yield AddPJPFailureState(
          messages: "Please check your internet connection");
    }
  }
}
