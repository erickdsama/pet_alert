import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pet_alert/repo/location.dart';
import './bloc.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationRepo locationRepo;
  LocationBloc(this.locationRepo);

  @override
  LocationState get initialState => LocationInitialState();

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if (event is FetchLocationEvent) {
      try {
        yield LocationIsFetchingState();
        Position position = await locationRepo.getLocation();

        if (position != null) {
          yield LocationIsFetchedState(position: position);
        } else {
          yield LocationErrorState();
        }
        // yield LocationErrorState();

      }catch(e){
        print("$e");
      }

    }
  }


}

