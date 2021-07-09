import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pet_alert/bloc/alert_bloc.dart';
import 'package:pet_alert/bloc/alert_state.dart';
import 'package:pet_alert/widgets/list_alert_item.dart';
import 'package:pet_alert/widgets/list_widget_item.dart';

import '../styles.dart';


class MyAlerts extends StatelessWidget {

  Widget noAlerts(context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:  [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child:
            Image.asset("assets/images/logo.png", color: Colors.grey, width: 100, fit: BoxFit.fitWidth,),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text("oh! \n No hay Alertas registradas", style: descList, textAlign: TextAlign.center,),
          ),
        ),
        CupertinoButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(MaterialIcons.add, size: 30,),
              Text("Agregar")
            ],
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/newAlert', arguments: {});

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
        child: BlocBuilder<AlertBloc, AlertState>(
          builder: (context, state){
            if(state is AlertIsLoadedState) {
              if (state.alertModels.length > -1 ) {
                return ListView.builder(
                  itemCount: state.alertModels.length,
                  itemBuilder: (BuildContext ctx, int idx) {
                    return Dismissible(
                        movementDuration: Duration(seconds: 2),
                        key: Key(state.alertModels[idx].id.toString()),
                        child: ListAlertItem(alertModel: state.alertModels[idx],)
                    );
                  },
                );
              }
            } else {
              return noAlerts(context);

            }
            return noAlerts(context);
          },
        )
    );
  }
}