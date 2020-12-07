import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PetsEvent extends Equatable{
  const PetsEvent();
  @override
  List<Object> get props => [];

}

class FetchPets extends PetsEvent {
  FetchPets();
  @override
  List<Object> get props => [];

}
