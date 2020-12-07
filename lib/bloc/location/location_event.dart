import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LocationEvent extends Equatable{
  const LocationEvent();
  @override
  List<Object> get props => [];

}
class FetchLocationEvent extends LocationEvent {
  List<Object> get props => [];
}

class PermissionRequestLocationEvent extends LocationEvent {
  List<Object> get props => [];
}
