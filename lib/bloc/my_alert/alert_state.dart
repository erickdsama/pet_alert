import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:pet_alert/models/AlertModel.dart';

@immutable
abstract class AlertState extends Equatable{
  const AlertState();
  @override
  List<Object> get props => [];
}

class AlertInitialState extends AlertState {}


class AlertLoadingState  extends AlertState {}


class AlertIsLoadedState  extends AlertState {
  final List<AlertModel> alertModels;
  AlertIsLoadedState({@required this.alertModels});
  @override
  List<Object> get props => [alertModels];
}

class AlertIsNotLoadedState  extends AlertState {}

class MyAlertsIsNotLoadedState  extends AlertState {}

class MyAlertsIsLoadedState  extends AlertState {
  final List<AlertModel> alertModels;
  MyAlertsIsLoadedState({@required this.alertModels});
  @override
  List<Object> get props => [alertModels];
}

class MyAlertsLoadingState  extends AlertState {}
