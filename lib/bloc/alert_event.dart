import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AlertEvent extends Equatable{
  const AlertEvent();
  @override
  List<Object> get props => [];

}
class AlertFetchingLocation extends AlertEvent {
  @override
  List<Object> get props => [];
}

class FetchAlerts extends AlertEvent {
  final String lat;
  final String lon;
  FetchAlerts({@required this.lat, @required this.lon});

  @override
  List<Object> get props => [lat, lon];
}
class RequestLocation extends AlertEvent {
  @override
  List<Object> get props => [];
}

class FetchMyAlerts extends AlertEvent {
  FetchMyAlerts();
  @override
  List<Object> get props => [];
}