import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/alert_bloc.dart';
import 'package:pet_alert/bloc/chat/chat_bloc.dart';
import 'package:pet_alert/bloc/location/bloc.dart';
import 'package:pet_alert/bloc/pets/bloc.dart';
import 'package:pet_alert/pages/new_pet.dart';
import 'package:pet_alert/pages/screens/list_screen.dart';
import 'package:pet_alert/pages/screens/profile_screen.dart';
import 'package:pet_alert/repo/AlertRepo.dart';
import 'package:pet_alert/repo/PetRepo.dart';
import 'package:pet_alert/repo/location.dart';
import 'package:pet_alert/repo/user_repo.dart';

LocationRepo locationRepo = LocationRepo();
LocationBloc locationBloc = LocationBloc(locationRepo);


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  // BloC
  PetBloc petBloc;
  AlertBloc alertBloc;
  ChatBloc chatBloc;

  //repos
  PetRepo petRepo = PetRepo();
  AlertRepo alertRepo = AlertRepo();
  UserRepo userRepo = UserRepo();

  @override
  void initState() {
    petBloc = PetBloc(petRepo);
    locationBloc = BlocProvider.of<LocationBloc>(context);
    alertBloc = AlertBloc(alertRepo: alertRepo);
    chatBloc = ChatBloc(userRepo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new CupertinoTabScaffold(
      tabBuilder: (BuildContext context, int index) {
        if(index == 0) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AlertBloc>(
                  create: (context) => AlertBloc(alertRepo: alertRepo, locationBloc: locationBloc)
              ),
            ],
            child: ListScreen()
          );
        } else if(index == 1) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<PetBloc>.value(value: petBloc),
            ],
            child:  NewPetPage()
          );
        } else if(index == 2) {
          return MultiBlocProvider(
              providers: [
                BlocProvider<PetBloc>.value(value: petBloc),
                BlocProvider<AlertBloc>.value(value: alertBloc),
                BlocProvider<ChatBloc>.value(value: chatBloc)
              ], child: ProfileScreen()
          );
        }
        return ListScreen();
      },
      tabBar: new CupertinoTabBar(
          items: [
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.paw_solid), label: "Mascotas"),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.add_circled_solid), label: "Agregar"),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_alt_circle), label: "Profile"),
    ]),
    );
  }

  @override
  void dispose() {
    petBloc?.close();
    alertBloc?.close();
    chatBloc?.close();
    super.dispose();
  }
}