import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/alert_bloc.dart';
import 'package:pet_alert/bloc/alert_event.dart';
import 'package:pet_alert/bloc/alert_state.dart';
import 'package:pet_alert/bloc/location/bloc.dart';
import 'package:pet_alert/globals.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/widgets/list_alert_item.dart';
import 'package:pet_alert/widgets/list_widget_item.dart';

import '../../styles.dart';

class ListScreen extends StatefulWidget {
  static const String id = 'ListScreen';

  ListScreen(String key) {
  }

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  AlertBloc alertBloc;
  LocationBloc locationBloc;
  Key a = UniqueKey();

  ScrollController _scrollController = ScrollController();
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
    alertBloc = BlocProvider.of<AlertBloc>(context);
    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc?.listen((state) {
      if(state is LocationInitialState) {
        locationBloc.add(FetchLocationEvent());
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        // refresh when scroll top
        alertBloc.add(AlertFetchingLocation());
        locationBloc.add(FetchLocationEvent());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

            if (state is AlertInitialState || state is AlertLoadingState) {
              return Center(
                child: const CircularProgressIndicator(
                    strokeWidth: 5,
                    valueColor: AlwaysStoppedAnimation<Color>(primary)
                ),
              );
            } else if( state is AlertIsLoadedState){
              if (state.alertModels.length > 0) {
                return ListView.builder(
                    controller: _scrollController,
                    addAutomaticKeepAlives: true,
                    itemCount: state.alertModels.length,
                    itemBuilder: (BuildContext ctx, int idx) {
                      return ListAlertItem(alertModel: state.alertModels[idx]);
                    });
              } else {
                return notAlerts();
              }
            } else {
              return notAlerts();
            }
          },
        )
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
    alertBloc?.close();
    locationBloc.close();
  }
}