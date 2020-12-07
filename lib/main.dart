import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/alert_bloc.dart';
import 'package:pet_alert/bloc/pets/bloc.dart';
import 'package:pet_alert/globals.dart';
import 'package:pet_alert/pages/login.dart';
import 'package:pet_alert/pages/main_page.dart';
import 'package:pet_alert/repo/AlertRepo.dart';
import 'package:pet_alert/repo/PetRepo.dart';
import 'package:pet_alert/repo/location.dart';
import 'package:pet_alert/routing.dart';
import 'package:pet_alert/services/AuthService.dart';
import 'package:pet_alert/utils.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_state.dart';
import 'bloc/location/location_bloc.dart';


class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}


void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  var authService = AuthService();
  AlertRepo alertRepo = AlertRepo();
  PetRepo petRepo = PetRepo();
  LocationRepo locationRepo = LocationRepo();
  LocationBloc locationBloc = LocationBloc(locationRepo);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<PetBloc>(
        create: (context) => PetBloc(petRepo),
      ),
      BlocProvider<AlertBloc>(
        create: (context) => AlertBloc(alertRepo, locationBloc),
      ),
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc()),
    ],
    child: Main(authService: authService,),
  ));

//
//  runApp(
//    BlocProvider<AuthBloc>(
//      create: (context) {
//        return AuthBloc();
//      },
//      child: Main(authService: authService),
//    ),
//  );
}

class Main extends StatelessWidget {

  final AuthService authService;
  Main({Key key, @required this.authService}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return new CupertinoApp(
        theme:  CupertinoThemeData(
            primaryColor: primary,
            scaffoldBackgroundColor: primary
        ),
        debugShowCheckedModeBanner: true,
        title: appName,
        onGenerateRoute: Routing.generateRouting,
        home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state){
              return FutureBuilder(
                  future: getUser(),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done) {
                      User user = snapshot.data;
                      if (user != null) {
                        print("user $user");
                        return MainPage(user: user,);
                      } else {
                        return LoginPage(authService: authService);
                      }
                    } else if(snapshot.connectionState == ConnectionState.none) {
                      return LoginPage(authService: authService);
                    } else {
                      return CircularProgressIndicator();
                    }
                }
              );
            }
        ));
  }
}