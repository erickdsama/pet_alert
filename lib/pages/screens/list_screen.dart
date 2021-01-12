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

class ListScreen extends StatefulWidget {
  static const String id = 'ListScreen';
  ListScreen();

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  AlertBloc alertBloc;
  LocationBloc locationBloc;

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
  void initState() {
    print("INIIIIIIIIIIIIIIIIITTTTTT");
    alertBloc = BlocProvider.of<AlertBloc>(context);
    locationBloc = BlocProvider.of<LocationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    locationBloc.listen((state) {
      if (state is LocationInitialState) {
        locationBloc.add(FetchLocationEvent());
      } else if (state is LocationIsFetchedState) {

//        alertBloc.add(FetchAlerts(lat: state.position.latitude.toString(), lon: state.position.longitude.toString()));

      } else if(state is LocationErrorState ) {
        print("error");
//        locationBloc.add(FetchLocationEvent());
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
          bloc:  alertBloc,
          builder: (context, state){
            print("ldsajaksjdlkajdkajskldsjklasjkdasjdkljkdsajkldsajkldsjkdlasjladskjdsalkjdas $state}");
            if (state is AlertInitialState) {
              return CircularProgressIndicator();
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
            } else {
              return Container();
            }
          },
        )
        ),
    );
  }

  @override
  void dispose() {
    print("dispose");
    alertBloc?.close();
    super.dispose();
  }
}