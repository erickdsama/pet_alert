import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_alert/bloc/location/bloc.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/repo/AlertRepo.dart';
import './bloc.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final LocationBloc locationBloc;
  StreamSubscription locationBlocSuscription;
  AlertRepo alertRepo;
  AlertBloc({@required this.alertRepo, this.locationBloc}){
    if (locationBloc != null) {
      locationBlocSuscription = this.locationBloc.listen((state) {
        if (state is LocationIsFetchedState) {
          print("si estoy escuchando????");
          print("si estoy escuchando????");
          print("si estoy escuchando????");
          print("si estoy escuchando????");


          add(FetchAlerts(lat: state.position.latitude.toString(), lon: state.position.longitude.toString()));
        }
      });
    }
  }

  @override
  Future<void> close() {
    locationBlocSuscription?.cancel();
    return super.close();
  }

  @override
  AlertState get initialState => AlertInitialState();

  @override
  Stream<AlertState> mapEventToState(AlertEvent event) async* {
    print("SADAJSLDJASLDJSALDJASJLDALSJDLASJDASJDLSAJDLASJLDJASLDJSALDJASL");

    if (event is FetchAlerts) {
      try {
        yield AlertLoadingState();
        List<AlertModel> alertModel = await alertRepo.fetchNearbyAlertPets(event.lat, event.lon);
        if (alertModel != null) {
          yield AlertIsLoadedState(alertModels: alertModel);
        } else {
          yield AlertIsNotLoadedState();
        }
      }catch(e){
        print("$e");
      }
    } else if(event is FetchMyAlerts) {
      try {
        yield MyAlertsLoadingState();
        List<AlertModel> alertModel = await alertRepo.fetchMyAlerts();
        if (alertModel != null) {
          yield MyAlertsIsLoadedState(alertModels: alertModel);
        } else {
          yield MyAlertsIsNotLoadedState();
        }
      }catch(e){
        print("$e");
      }
    } else if (event is AlertFetchingLocation) {
      yield AlertLoadingState();
    }
  }
}
