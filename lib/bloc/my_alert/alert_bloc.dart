import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/repo/AlertRepo.dart';

import './bloc.dart';
import '../alert_event.dart';
import '../alert_state.dart';

class MyAlertBloc extends Bloc<AlertEvent, AlertState> {
  StreamSubscription locationBlocSuscription;
  AlertRepo alertRepo;
  MyAlertBloc({@required this.alertRepo});

  @override
  Future<void> close() {
    locationBlocSuscription?.cancel();
    return super.close();
  }

  @override
  AlertState get initialState => AlertInitialState();

  @override
  Stream<AlertState> mapEventToState(AlertEvent event) async* {
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
