import 'package:equatable/equatable.dart';

class SplashEvent extends Equatable {
  final String appVersion;
  final String deviceType;
  const SplashEvent({required this.appVersion, required this.deviceType});
  @override
  List<Object?> get props => [appVersion, deviceType];
}
