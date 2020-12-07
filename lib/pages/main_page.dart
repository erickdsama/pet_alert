import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/alert_bloc.dart';
import 'package:pet_alert/bloc/location/bloc.dart';
import 'package:pet_alert/bloc/pets/bloc.dart';
import 'package:pet_alert/pages/screens/list_screen.dart';
import 'package:pet_alert/pages/new_pet.dart';
import 'package:pet_alert/pages/screens/profile_screen.dart';
import 'package:pet_alert/repo/AlertRepo.dart';
import 'package:pet_alert/repo/PetRepo.dart';
import 'package:pet_alert/repo/location.dart';

LocationRepo locationRepo = LocationRepo();
LocationBloc locationBloc = LocationBloc(locationRepo);


class MainPage extends StatelessWidget {

  final User user;
  MainPage({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new CupertinoTabScaffold(
      tabBuilder: (BuildContext context, int index) {
        if(index == 0) {
          ListScreen(this.user);
        } else if(index == 1) {
          return NewPetPage(this.user);
        } else if(index == 2) {
          return ProfileScreen(this.user);
        }
        return ListScreen(this.user);
      },
      tabBar: new CupertinoTabBar(
          items: [
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.paw_solid), label: "Mascotas"),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.add_circled_solid), label: "Agregar"),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_alt_circle), label: "Profile"),
    ]),
    );
  }

}