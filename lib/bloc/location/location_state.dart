import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LocationState extends Equatable{
  const LocationState();
  @override
  List<Object> get props => [];
}

class LocationInitialState extends LocationState {}

class LocationIsFetchingState extends LocationState {}

class LocationIsFetchedState extends LocationState {
  final Position position;
  LocationIsFetchedState({@required this.position});
  @override
  List<Object> get props => [position];
}

class LocationErrorState extends LocationState {}

class LocationPermResponseState  extends LocationState {}

class LocationRequestPermState  extends LocationState {}

