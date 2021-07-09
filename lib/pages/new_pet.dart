
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
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text("Nueva Mascota"),
            backgroundColor: Colors.transparent,
            border: null,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((ctx, idx) {
              return Card(
                elevation: 0,
                color: Colors.transparent,
                child:NewPetForm());
            }, childCount: 1),key: Key("dsadsa"),
          )
        ],
      )
    );
  }

}