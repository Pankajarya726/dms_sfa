import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/report_screen/bloc/report_event.dart';
import 'package:sfa/ui/report_screen/bloc/report_state.dart';
import 'package:sfa/ui/report_screen/model/report_model.dart';
import 'package:sfa/utility/network.dart';

class ReportBloc extends Bloc<ReportEvents, ReportState> {
  ReportBloc() : super(ReportInitialState());
  @override
  Stream<ReportState> mapEventToState(ReportEvents event) async* {
    if (event is GetReportEvent) {
      yield ReportLoadingState();
      yield* getReportData(event);
    }
  }

  Stream<ReportState> getReportData(GetReportEvent event) async* {
    if (await Network.isConnected()) {
      ReportResponse response = await repository.getReport(
          event.initDate,
          event.endDate,
          event.filterName,
          event.locationType,
          event.locationId);

      if (response.success) {
        yield ReportSuccessState(response: response);
      } else {
        yield ReportFailureState(message: "Data not found");
      }
    } else {
      yield ReportNetworkState(message: "Network not connected");
    }
  }
}
