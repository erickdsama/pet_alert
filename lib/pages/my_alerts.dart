import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pet_alert/bloc/alert_bloc.dart';
import 'package:pet_alert/bloc/alert_state.dart';
import 'package:pet_alert/widgets/list_widget_item.dart';

import '../styles.dart';


class MyAlerts extends StatelessWidget {

  Widget noAlerts(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child:
          Image.asset("assets/images/logo.png", color: Colors.grey, width: 100, fit: BoxFit.fitWidth,),
        ),
        Center(
          child: Text("No hay alertas registradas", style: subText),
        ),
        CupertinoButton(
          child: Icon(MaterialIcons.add, size: 30,),
          onPressed: () {

          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new CupertinoPageScaffold(
        backgroundColor: Colors.white,
        navigationBar: CupertinoNavigationBar(
          middle: Text("Mis Alertas"),
        ),
        child: BlocConsumer<AlertBloc, AlertState>(
          listener: (context, state) {

          },
          builder: (context, state){
            return noAlerts();
          },
        )
    );
  }
}