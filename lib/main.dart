import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/alert_bloc.dart';
import 'package:pet_alert/bloc/login/bloc.dart';
import 'package:pet_alert/bloc/my_alert/alert_bloc.dart';
import 'package:pet_alert/bloc/pets/bloc.dart';
import 'package:pet_alert/globals.dart';
import 'package:pet_alert/pages/login.dart';
import 'package:pet_alert/pages/main_page.dart';
import 'package:pet_alert/repo/AlertRepo.dart';
import 'package:pet_alert/repo/PetRepo.dart';
import 'package:pet_alert/repo/location.dart';
import 'package:pet_alert/repo/login_repo.dart';
import 'package:pet_alert/repo/user_repo.dart';
import 'package:pet_alert/routing.dart';

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
LoginRepo loginRepo = LoginRepo();
UserRepo userRepo = UserRepo();
LocationRepo locationRepo = LocationRepo();
PetRepo petRepo = PetRepo();
AlertRepo alertRepo = AlertRepo();

LoginBloc loginBloc = LoginBloc(loginRepo: loginRepo, userRepo: userRepo);
LocationBloc locationBloc = LocationBloc(locationRepo);
AlertBloc alertsBloc = AlertBloc(alertRepo: alertRepo, locationBloc: locationBloc);
MyAlertBloc myAlertBloc = MyAlertBloc(alertRepo: alertRepo);
PetBloc petBloc = PetBloc(petRepo);



void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<LocationBloc>(
        create: (context) =>  locationBloc
      ),
      BlocProvider<LoginBloc>.value(
        value: loginBloc,
      ),
      BlocProvider<AlertBloc>(
          create: (context) =>  alertsBloc
      ),
      BlocProvider<MyAlertBloc>(
          create: (context) =>  myAlertBloc
      ),
      BlocProvider<PetBloc>.value(
        value: petBloc,
      ),
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(loginBloc: loginBloc)),
    ],
    child: Main(),
  ));


}

class Main extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainState();

}


class _MainState extends State<Main> {
  Routing routing = Routing();
  MainTabPage mainTabPage = MainTabPage();
  LoginPage loginPage = LoginPage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new CupertinoApp(
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],

        theme:  CupertinoThemeData(
            primaryColor: primary,
            primaryContrastingColor: Colors.teal,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white
        ),
        debugShowCheckedModeBanner: true,
        title: appName,
        onGenerateRoute: routing.generateRouting,
        home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state){
              if (state is AuthenticatedState) {
                return mainTabPage;
              } else if(state is InitialAuthState) {
                // return mainTabPage;
                return LoginPage();
              } else {
                return mainTabPage;
                // return LoginPage();
              }
            }
        ));
  }

  @override
  void dispose() {
    petBloc?.close();
    alertsBloc?.close();
    loginBloc?.close();
    locationBloc?.close();
    myAlertBloc?.close();
    routing.dispose();
    super.dispose();
  }
}