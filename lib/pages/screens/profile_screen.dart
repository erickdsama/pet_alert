import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/alert_bloc.dart';
import 'package:pet_alert/bloc/alert_event.dart';
import 'package:pet_alert/bloc/bloc.dart';
import 'package:pet_alert/bloc/chat/chat_bloc.dart';
import 'package:pet_alert/bloc/pets/bloc.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/models/PetModel.dart';
import 'package:pet_alert/repo/PetRepo.dart';
import 'package:pet_alert/styles.dart';
import 'package:pet_alert/utils.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'ProfileScreen';

  ProfileScreen();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  // BloC
  PetBloc petBloc;
  AlertBloc alertBloc;
  ChatBloc chatBloc;

  @override
  void initState() {
    alertBloc = BlocProvider.of<AlertBloc>(context);
    petBloc = BlocProvider.of<PetBloc>(context);
    alertBloc.add(FetchMyAlerts());
    petBloc.listen((state) {
      if(state is PetsInitialState || state is SavedPet) {
        petBloc.add(FetchPets());
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                    BlocProvider(
                        create: (context) => petBloc,
                        child: Material(
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
                               Text("0");
                             }
                             return Text("0");
                            }
                          )
                        )
                    ),
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

  @override
  void dispose() {
    alertBloc?.close();
    chatBloc?.close();
    super.dispose();
  }

}