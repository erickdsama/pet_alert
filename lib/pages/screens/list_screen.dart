import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/alert_bloc.dart';
import 'package:pet_alert/bloc/alert_event.dart';
import 'package:pet_alert/bloc/alert_state.dart';
import 'package:pet_alert/bloc/location/bloc.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/widgets/list_alert_item.dart';
import 'package:pet_alert/widgets/list_widget_item.dart';

import '../../styles.dart';

class ListScreen extends StatelessWidget {
  static const String id = 'ListScreen';
  final User user;
  ListScreen(
      this.user
      );

  Widget notAlerts(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child:
          Image.asset("assets/images/logo.png", color: Colors.grey, width: 100, fit: BoxFit.fitWidth,),
        ),
        Center(
          child: Text("No hay mascotas reportadas", style: subText),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LocationBloc>(context).listen((state) {
      if (state is LocationInitialState) {
        BlocProvider.of<LocationBloc>(context).add(FetchLocationEvent());
      }
    });

    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
          middle: Text("Mascotas Reportadas"),
          transitionBetweenRoutes: false // here!
      ),
      child: GestureDetector(
        child: BlocBuilder<AlertBloc, AlertState>(
          bloc:  BlocProvider.of<AlertBloc>(context),
          builder: (context, state){
            if (state is AlertInitialState) {
              return notAlerts();
            } else if(state is AlertLoadingState) {
              return CircularProgressIndicator();
            } else if( state is AlertIsLoadedState){
              if (state.alertModels.length > 0) {
                return ListView.builder(
                    itemCount: state.alertModels.length,
                    itemBuilder: (BuildContext ctx, int idx) {
                      return ListAlertItem(alertModel: state.alertModels[idx]);
                    });
              } else {
                return notAlerts();
              }
            }
            return notAlerts();
          },
        )
        ),
    );
  }
}