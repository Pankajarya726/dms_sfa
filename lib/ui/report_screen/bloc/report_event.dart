import 'package:equatable/equatable.dart';

class ReportEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetReportEvent extends ReportEvents {
  final String? initDate;
  final String? endDate;
  final String? filterName;
  final String? locationType;
  final String? locationId;
  GetReportEvent(
      {this.initDate,
      this.endDate,
      this.filterName,
      this.locationType,
      this.locationId});
  @override
  List<Object?> get props =>
      [initDate, endDate, filterName, locationType, locationId];
}
