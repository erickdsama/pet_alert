import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pet_alert/models/PetModel.dart';
import 'package:pet_alert/repo/PetRepo.dart';
import './bloc.dart';

class PetBloc extends Bloc<PetsEvent, PetState> {

  PetRepo petRepo;
  PetBloc(this.petRepo){
  }
  @override
  PetState get initialState => PetsInitialState();

  @override
  Stream<PetState> mapEventToState(
    PetsEvent event,
  ) async* {
    if (event is FetchPets) {
      try {
        yield PetsIsLoadingState();
        List<PetModel> petsModel = await petRepo.fetchMyPets();
        if (petsModel != null) {
          yield PetsIsLoadedState(petsModel: petsModel);
        } else {
          yield PetIsNotLoaded();
        }
      }catch(e){
        print("$e");
      }
    } else if(event is SavePet) {
      yield SavingPet();
      PetModel petModel;
      try {
        petModel = await petRepo.savePet(event.petModel);
      } catch(e) {
        yield ErrorSavingPet(error: e.toString());
      }
      if (petModel != null) {
        yield SavedPet(petModel: petModel);
      } else {
        yield ErrorSavingPet(error: "Problem on saving Pet");
      }
    }
  }
}
