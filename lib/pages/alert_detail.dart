import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_alert/bloc/auth/auth_bloc.dart';
import 'package:pet_alert/bloc/auth/auth_state.dart';
import 'package:pet_alert/bloc/login/bloc.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/models/UserModel.dart';
import 'package:pet_alert/pages/forms/direct_message.dart';
import 'package:pet_alert/services/AuthService.dart';
import 'package:pet_alert/styles.dart';
import 'package:pet_alert/widgets/list_comment_item.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../globals.dart';
import 'forms/loginForm.dart';



class AlertDetailPage extends StatelessWidget{
  final AlertModel alertModel;
  final List<LatLng> latlng = [];
  UserModel loginUserModel;


  Set<Polygon> _polygons = Set<Polygon>();
  AlertDetailPage({Key key, this.alertModel}) : super(key: key);

  Widget listIconDetail(icon, key, value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(key, style: labels,), flex: 6,),
          Expanded(child: Text(value, style: descList,), flex: 3,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //variables transform
    var parsedDate = DateTime.parse(alertModel.lost_date);
    String missingDate = timeago.format(parsedDate, locale: 'es');
    //google maps
    Completer<GoogleMapController> _controller = Completer();
    List<dynamic> coordinates = alertModel.lostPoint['coordinates'][0];

    for(final list_latlng in coordinates) {
      latlng.add(new LatLng(list_latlng[1], list_latlng[0]));
    }

    final CameraPosition _kGooglePlex = CameraPosition(
      target: latlng[0],
      zoom: 14,
    );
    _polygons.add(Polygon(
        polygonId: PolygonId("radius_lost"),
        points: latlng,
        strokeWidth: 2,
        fillColor: Color(0x440044BB),
        strokeColor: Color(0x440044BB)
    ));

    return new CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: BlocProvider(
          create: (context) {
            return LoginBloc();
          },
        child: Container(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Image.network(alertModel.pet.photo, fit: BoxFit.fitWidth, height: 300, ),
                ),
                width: double.infinity,
              ),
              Card(
                child:
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("${alertModel.pet.name}", style: title,)
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text("Reportado por: ${alertModel.pet.owner.name}"),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.center,
                                child: SizedBox(
                                width: 50,
                                height: 50,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Image.network('${alertModel.pet.photo}', height: 50, width: 50, fit: BoxFit.fill )
                                )
                            )
                          )
                          )
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                  children: [
                                    Icon(MaterialCommunityIcons.human_male_height),
                                    Text(""),
                                    Text("30 a 50cm", textAlign: TextAlign.center, style: subText)
                                  ]
                              )
                            )
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                  children: [
                                    Icon(Ionicons.ios_color_palette),
                                    Text(""),
                                    Text("${alertModel.pet.color}", textAlign: TextAlign.center, style: subText,)
                                  ]
                              )
                            )
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                  children: [
                                    Icon(FontAwesome5Solid.dna),
                                    Text(""),
                                    Text("${alertModel.pet.breed}", textAlign: TextAlign.center, style: subText,)
                                  ]
                              )
                            )
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                  children: [
                                    Icon(MaterialCommunityIcons.timer_sand),
                                    Text(""),
                                    Text("$missingDate", textAlign: TextAlign.center, style: subText,)
                                  ]
                              )
                            )
                          ),
                        ],
                      ),
                        Row(
                        children: [
                          Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ExpansionTile(
                                      initiallyExpanded: false,
                                      title: Text("Más sobre ${alertModel.pet.name}:", style: labels,),
                                      children: [
                                        listIconDetail(FontAwesome5Solid.dna, "Raza", alertModel.pet.breed),
                                        listIconDetail(MaterialCommunityIcons.human_male_height, "Tamaño", alertModel.pet.size),
                                        listIconDetail(Ionicons.ios_color_palette, "Color", alertModel.pet.color),
                                        listIconDetail(FontAwesome.venus_mars, "Sex", alertModel.pet.sex == 1 ? "Hembra" : "Macho" ),
                                        listIconDetail(Icons.warning, "Problemas", alertModel.pet.disease == null ? "N/A" : alertModel.pet.disease),
                                        listIconDetail(Icons.medical_services, "Medicinas", alertModel.pet.medicates == null ? "N/A" : alertModel.pet.medicates),
                                      ],
                                    ),
                                    Text(""),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: BlocBuilder<AuthBloc, AuthState>(
                                                  bloc: BlocProvider.of<AuthBloc>(context),
                                                  builder: (context, state) {
                                                    if (state is AuthenticatedState) {
                                                      return DirectMessageForm(
                                                        loginUser: state.userModel,
                                                        reportAlertUser: alertModel.pet.owner,
                                                      );
                                                    } else {
                                                      return Container();
                                                    }
                                                  })
                                          )
                                        ],
                                      ),
                                    )
                                  ]
                              )
                          ),
                        ]
                      ),
                      Divider(),
                      Row(
                        children: [
                          SizedBox(
                            child: GoogleMap(
                            mapType: MapType.normal,
                              polygons: this._polygons,
                              zoomControlsEnabled: true,
                              scrollGesturesEnabled: true,
                              initialCameraPosition: _kGooglePlex,
                              onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                            width: MediaQuery.of(context).size.width - 40,  // or use fixed size like 200
                            height: 400,
                          )

                        ],
                      )
                    ],
                  ),
                )
              ),
            ],
          )
        ),
      )
    );
  }
}
