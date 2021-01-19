import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_alert/bloc/login/bloc.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/pages/forms/direct_message.dart';
import 'package:pet_alert/services/AuthService.dart';
import 'package:pet_alert/styles.dart';
import 'package:pet_alert/widgets/list_comment_item.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../globals.dart';
import 'forms/loginForm.dart';



class PetDetailPage extends StatelessWidget{
  final AuthService authService;
  final AlertModel alertModel;
  final List<LatLng> latlng = [];

  Set<Polygon> _polygons = Set<Polygon>();
  PetDetailPage({Key key, @required this.authService, this.alertModel}) : super(key: key);

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
                            child: Text("Reportado por: \nErick Samaniego"),
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
                                    Text("${missingDate}", textAlign: TextAlign.center, style: subText,)
                                  ]
                              )
                            )
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text("Sobre ${alertModel.pet.name}", style: secondTitle,)
                                        ),
                                      ],
                                    ),
                                    Text(""),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex:9,
                                            child: Text("${alertModel.description}", softWrap: true, maxLines: 2,)
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CupertinoButton(
                                            child: Icon(Icons.message),
                                            onPressed: (){

                                            },
                                          )
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: DirectMessageForm())
                                      ],
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
//              Expanded(
//                flex: 2,
//                child: Container(
//                  color: greyLight,
//                  padding: EdgeInsets.only(left: 8, right: 8),
//                  child: Row(
//                    children: [
//                      Expanded(flex:1, child: CupertinoButton(
//                        child: Icon(CupertinoIcons.location_solid, color: primary,),
//                        onPressed: () => {
//                        },
//                      )),
//                      Expanded(flex:7, child: CupertinoTextField(
//                        maxLines: 2,
//                        placeholder: "Escribe un comentario",
//                      )),
//                      Expanded(flex:2, child: CupertinoButton(
//                        child: Icon(CupertinoIcons.paperplane, color: primary,),
//                        onPressed: () => {
//                        },
//                      ))
//                    ],
//                  ),
//                ),
//              ))

