import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/login/bloc.dart';
import 'package:pet_alert/globals.dart';
import 'package:pet_alert/pages/login.dart';
import 'package:pet_alert/pages/main_page.dart';
import 'package:pet_alert/repo/location.dart';
import 'package:pet_alert/repo/login_repo.dart';
import 'package:pet_alert/repo/user_repo.dart';
import 'package:pet_alert/routing.dart';
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
  LoginRepo loginRepo = LoginRepo();
  UserRepo userRepo = UserRepo();
  LocationRepo locationRepo = LocationRepo();
  LoginBloc loginBloc = LoginBloc(loginRepo: loginRepo, userRepo: userRepo);
  LocationBloc locationBloc = LocationBloc(locationRepo);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<LocationBloc>(
        create: (context) =>  locationBloc
      ),
      BlocProvider<LoginBloc>.value(
        value: loginBloc,
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

  @override
  void initState() {
    routing.init();
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
            scaffoldBackgroundColor: primary
        ),
        debugShowCheckedModeBanner: true,
        title: appName,
        onGenerateRoute: routing.generateRouting,
        home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state){
              if (state is AuthenticatedState) {
                return MainPage();
              } else {
                return FutureBuilder(
                    future: getUser(),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done) {
                        User user = snapshot.data;
                        if (user != null) {
                          return MainPage();
                        } else {
                          return LoginPage();
                        }
                      } else if(snapshot.connectionState == ConnectionState.none) {
                        return LoginPage();
                      } else {
                        return CircularProgressIndicator();
                      }
                  }
                );
              }
            }
        ));
  }


  @override
  void dispose() {
    routing.dispose();
    super.dispose();
  }
}