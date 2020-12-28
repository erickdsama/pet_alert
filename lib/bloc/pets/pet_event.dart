import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pet_alert/models/PetModel.dart';

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

class SavePet extends PetsEvent {
  final PetModel petModel;
  SavePet({@required this.petModel});

  @override
  List<Object> get props => [petModel];
}