
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/login/login_bloc.dart';
import 'package:pet_alert/bloc/pets/pet_bloc.dart';
import 'package:pet_alert/bloc/pets/pet_state.dart';
import 'package:pet_alert/globals.dart';
import 'package:pet_alert/pages/forms/newPetForm.dart';
import 'package:pet_alert/styles.dart';

class NewPetPage extends StatelessWidget {
  NewPetPage();

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Nueva Mascota", style: whiteTitle,),
        automaticallyImplyLeading: true,
        backgroundColor: Color(0x0000000),
        border: null,
      ),
      child: Container(
        decoration:  BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 1],
                colors: [primary, primarySecond]
            )),
        constraints: BoxConstraints.expand(),
        child: Stack(
          children: [
            Container(
              constraints: new BoxConstraints.expand(height: 200.0),
            ),
            Positioned(
              left: 8.0,
              top: 100.0,
                bottom: 0.0,
                width: MediaQuery.of(context).size.width - 16,
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    Card(child:NewPetForm())
                  ],
                )
            )
          ],
        ),
      )
    );
  }

}