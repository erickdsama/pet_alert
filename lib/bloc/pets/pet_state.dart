import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pet_alert/models/PetModel.dart';

@immutable
abstract class PetState extends Equatable{
  const PetState();
  @override
  List<Object> get props => [];
}

class PetsInitialState extends PetState {}


class PetsIsLoadingState  extends PetState {}

class PetsIsLoadedState  extends PetState {
  final List<PetModel> petsModel;
  PetsIsLoadedState({@required this.petsModel});
  @override
  List<Object> get props => [petsModel];
}

class PetIsNotLoaded extends PetState {}


class SavingPet extends PetState {}

class SavedPet extends PetState {
  final PetModel petModel;
  SavedPet({@required this.petModel});

  @override
  List<Object> get props => [petModel];
}

class ErrorSavingPet extends PetState {
  final String error;

  ErrorSavingPet({@required this.error});

  @override
  List<Object> get props => [error];

}
