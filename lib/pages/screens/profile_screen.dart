import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/alert_bloc.dart';
import 'package:pet_alert/bloc/alert_event.dart';
import 'package:pet_alert/bloc/bloc.dart';
import 'package:pet_alert/bloc/pets/bloc.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/models/PetModel.dart';
import 'package:pet_alert/styles.dart';
import 'package:pet_alert/utils.dart';
import 'package:couchbase_lite/couchbase_lite.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'ProfileScreen';
  final User user;
  Database database;
  Replicator replicator;
  ListenerToken _dbListenerToken;

  ProfileScreen(
      this.user
      );

  Future<String> replicate() async{
    // Create replicators to push and pull changes to and from the cloud.
    database = await Database.initWithName("pet_alert_messa");

    ReplicatorConfiguration config =
    ReplicatorConfiguration(database, "ws://138.68.249.12:4984/pet_alert/");
      config.replicatorType = ReplicatorType.pushAndPull;
    config.continuous = true;

//    config.authenticator = BasicAuthenticator("petApp", "passApp");
    config.channels = ["sender22"];
//    config.pullAttributeFilters = {
//      "sender": [1],
//      "receiver": [99]
//    };
    var replicator = Replicator(config);
    print(" >>> WHATPPPP??? $replicator");
    ListenerToken _listenerToken;



    // Listen to replicator change events.
    _listenerToken = replicator.addChangeListener((ReplicatorChange event) {
      if (event.status.error != null) {
        print(">>>> Error: " + event.status.error);
      }
      print(" >>> data: ${event.status.activity.toString()}");
    });
    print("replica??????");



    _dbListenerToken = database.addChangeListener((dbChange) {
      for (var change in dbChange.documentIDs) {
        database.document(change).then((value) => print("doc ${value}")).catchError((err)=>print("dsadsadsa $err"));

        print("change in id: $change");
      }
    });
    replicator.start();

  }

  @override
  Widget build(BuildContext context) {

    replicate();
    BlocProvider.of<AlertBloc>(context).add(FetchMyAlerts());
    BlocProvider.of<PetBloc>(context).listen((state) {
      if(state is PetsInitialState) {
        BlocProvider.of<PetBloc>(context).add(FetchPets());
      }
    });
    BlocProvider.of<AlertBloc>(context).listen((state) {
      if(state is AlertInitialState) {
        BlocProvider.of<AlertBloc>(context).add(FetchMyAlerts());
      }
    });

    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        middle: Text("Mi perfil"),
          trailing: CupertinoButton(child: Icon(CupertinoIcons.pencil), onPressed: (){},),
          border: null,
          transitionBetweenRoutes: false // here!
      ),
          child: FutureBuilder(
            future: getUser(),
            builder: (context, request){
              if (request.connectionState == ConnectionState.done) {
                User user = request.data;
                String usuario = "";
                String email = "";
                String photoPath = "";
                if(user != null) {
                  usuario = user.displayName;
                  email = user.email;
                  photoPath = user.photoURL;
                }
                return ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100.0),
                                        child: Image.network(photoPath, height: 100, width: 100, fit: BoxFit.fill )
                                    )
                                )
                            )
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(usuario, style: title,),
                              Text(email, style: subText,),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Material(
                        child: ListTile(
                          title: Text("Mensajes", style: titleList,),
                          trailing: Text("1"),
                          onTap: () {
                            Navigator.pushNamed(context, '/myChats', arguments: {});
                            },
                        )
                    ),
                    Material(
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/myPets', arguments: {});
                          },
                          title: Text("Mis Mascotas",
                            style: titleList,
                          ),
                          trailing: BlocBuilder<PetBloc, PetState>(
                            builder: (context, state){
                             if(state is PetsIsLoadedState) {
                               List<PetModel> pets = state.petsModel;
                               return Text("${pets.length}");
                             } else {
                               Text("");
                             }
                             return Text("");
                            }
                          )
                        )
                    ),
                    Material(
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/myAlerts', arguments: {});

                          },
                          title: Text("Mis Alertas", style: titleList,),
                          trailing: BlocBuilder<AlertBloc, AlertState>(
                            builder: (context, state) {
                              if (state is AlertIsLoadedState) {
                                List<AlertModel> alerts = state.alertModels;
                                return Text("${alerts.length}");
                              } else {
                                return Text("");
                              }
                            }
                          ),
                        )
                    ),
                    Material(child: ListTile(title: Text("Configuración", style: titleList,))),
                    CupertinoButton(child: Text("Cerrar Sesión", style: accentText,), onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.popAndPushNamed(context, '/login', arguments: {});
                    })
                  ],
                );
              } else if(request.connectionState == ConnectionState.none) {
                Navigator.popAndPushNamed(context, '/login', arguments: {});
                return null;
              } else {
                return CircularProgressIndicator();
              }
            }
          )
    );
  }
}