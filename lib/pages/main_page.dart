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


//class MainPage extends StatefulWidget {
//  @override
//  _MainPageState createState() => _MainPageState();
//}

class MainTabPage extends StatelessWidget {

  // BloC
  PetBloc petBloc;
  AlertBloc alertBloc;
  AlertBloc myAlertsBloc;
  ChatBloc chatBloc;

  //repos
  PetRepo petRepo = PetRepo();
  AlertRepo alertRepo = AlertRepo();
  UserRepo userRepo = UserRepo();
  CupertinoTabScaffold mainTabScaffold;

  ListScreen listScreen = ListScreen();
  ProfileScreen profileScreen = ProfileScreen();


  int currentScreen = 0;
  CupertinoTabController _tabController = CupertinoTabController(
    initialIndex: 0
  );
  @override
  Widget build(BuildContext context) {
    print("cuantas veces entro");
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBuilder: (BuildContext context, int index) {
        print("when is callllllllll $index");
        if(index == 0) {
          print("HEEEERRREEEEEE");
          Widget blocProvider =  MultiBlocProvider(
              providers: [
                BlocProvider<AlertBloc>.value(value: alertBloc,)
              ],
              child: listScreen
          );
          return blocProvider;
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
                BlocProvider<AlertBloc>.value(value: myAlertsBloc),
                BlocProvider<ChatBloc>.value(value: chatBloc)
              ], child: profileScreen
          );
        } else {
          return  MultiBlocProvider(
              providers: [
                BlocProvider<AlertBloc>.value(value: alertBloc,)
              ],
              child: listScreen
          );
        }
      },
      tabBar: new CupertinoTabBar(
          items: [
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.paw_solid), label: "Mascotas"),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.add_circled_solid), label: "Agregar"),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_alt_circle), label: "Profile"),
          ]),
    );
  }


  CupertinoTabScaffold buildScaffold() {

  }

}