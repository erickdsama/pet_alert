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
  final List<AlertModel> alertModel;
  AlertIsLoadedState({@required this.alertModel});
  @override
  List<Object> get props => [alertModel];
}

class AlertIsNotLoadedState  extends AlertState {}
