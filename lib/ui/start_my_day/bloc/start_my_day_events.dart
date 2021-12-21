import 'package:equatable/equatable.dart';

class StartMyDayEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetQuotesAndImagesEvent extends StartMyDayEvents {
  @override
  List<Object> get props => [];
}

class StartMyDayEvent extends StartMyDayEvents {
  final String primaryTag;
  final String secondaryTag;
  final String remark;
  final String latitude;
  final String longitude;
  final int getMeeting;
  final String startDayImage;
  final String primaryTagId;
  final String secondaryTagId;
  StartMyDayEvent({
    required this.primaryTag,
    required this.secondaryTag,
    required this.remark,
    required this.latitude,
    required this.longitude,
    required this.getMeeting,
    required this.startDayImage,
    required this.primaryTagId,
    required this.secondaryTagId,
  });
  @override
  List<Object> get props => [
        primaryTag,
        secondaryTag,
        remark,
        latitude,
        longitude,
        getMeeting,
        startDayImage,
        primaryTagId,
        secondaryTagId,
      ];
}
