import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/bottom_sheet/filter_bloc/filter_event.dart';
import 'package:sfa/ui/bottom_sheet/filter_bloc/filter_state.dart';
import 'package:sfa/ui/bottom_sheet/filter_model/filter_model.dart';

class FilterBloc extends Bloc<FilterEvents, FilterState> {
  FilterBloc() : super(FilterInitialState());
  @override
  Stream<FilterState> mapEventToState(FilterEvents event) async* {
    if (event is FilterEvent) {
      yield* getFilterDate(event);
    }
  }

  Stream<FilterState> getFilterDate(FilterEvent event) async* {
    FiltersResponse response =
        await repository.getFiltersData(event.locationType);
    if (response.success) {
      yield FilterSuccessState(response: response);
    }
  }
}
