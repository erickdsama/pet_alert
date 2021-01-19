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
import 'package:pet_alert/repo/user_repo.dart';


class MainTabPage extends StatefulWidget {

  // BloC
  @override
  _MainTabPageState createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  UniqueKey a = UniqueKey();
  PetBloc petBloc;
  AlertBloc alertBloc;
  AlertBloc myAlertsBloc;
  ChatBloc chatBloc;
  PetRepo petRepo = PetRepo();
  AlertRepo alertRepo = AlertRepo();
  UserRepo userRepo = UserRepo();
  CupertinoTabScaffold mainTabScaffold;
  ListScreen listScreen;
  ProfileScreen profileScreen = ProfileScreen();
  int currentScreen = 0;
  CupertinoTabController _tabController = CupertinoTabController(
    initialIndex: 0
  );

  Widget blocProvider;
  @override
  void initState() {
    super.initState();
    listScreen = ListScreen(a.toString());
    LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    alertBloc = AlertBloc(alertRepo: alertRepo, locationBloc: locationBloc);
    myAlertsBloc = AlertBloc(alertRepo: alertRepo);
    petBloc = PetBloc(petRepo);
    blocProvider =  MultiBlocProvider(
        providers: [
          BlocProvider<AlertBloc>.value(value: alertBloc)
        ],
        child: listScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBuilder: (BuildContext context, int index) {
        if(index == 0) {
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
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.paw_solid), label: "Alertas"),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.add_circled_solid), label: "Agregar"),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_alt_circle), label: "Profile"),
          ]),
    );
  }

  CupertinoTabScaffold buildScaffold() {

  }

  @override
  void dispose() {
    super.dispose();

    print("DISPOOOOOOOOOOSSSSSSEEEEEE");
    alertBloc?.close();
    petBloc?.close();
    chatBloc?.close();
    myAlertsBloc?.close();
    alertBloc?.close();
    // TODO: implement dispose
  }
}