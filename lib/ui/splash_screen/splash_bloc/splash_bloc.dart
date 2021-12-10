import 'package:dms/ui/splash_screen/model/splash_model.dart';
import 'package:dms/ui/splash_screen/splash_bloc/splash_event.dart';
import 'package:dms/ui/splash_screen/splash_bloc/splash_state.dart';
import 'package:dms/utils/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../main.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitialState());
  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is SplashEvent) {
      yield* getData(event);
    }
  }

  Stream<SplashState> getData(SplashEvent event) async* {
    if (await Network.isConnected()) {
      SplashResponse response = await repository.validateAppVersion(
          event.appVersion, event.deviceType);
      if (response.success) {
        yield SplashSuccessState(response: response);
      } else {
        yield SplashFailureState(message: response.message);
      }
    } else {
      yield SplashNetworkState(message: "Network not connected");
    }
  }
}
