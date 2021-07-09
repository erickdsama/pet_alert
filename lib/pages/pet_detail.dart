import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pet_alert/globals.dart';
import 'package:pet_alert/models/PetModel.dart';
import 'package:pet_alert/utils.dart';
import 'package:pet_alert/widgets/box_characteristic_item.dart';


class PetDetailPage extends StatelessWidget{

  final PetModel petModel;


  PetDetailPage({this.petModel});

  @override
  Widget build(BuildContext context) {
    IconData iconAnimal = petModel.sex == 0 ? FontAwesome5Solid.venus : FontAwesome5Solid.mars;
    return new CupertinoPageScaffold(
      backgroundColor: Color(0xFFEFEFEF),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.7,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              centerTitle: true,
              background: CachedNetworkImage(
                imageUrl: "http://$URL_API/files/${petModel.photo}",
                height: 400,
                fit: BoxFit.cover,
                useOldImageOnUrlChange: false,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("${capitalize(petModel.name)}", style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Icon(iconAnimal, size: 20, color: accentColor,),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Text("${capitalize(petModel.breed)}", style: Theme.of(context).textTheme.bodyText2,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  BoxCharacteristicItem(
                                    title: "Tamaño",
                                    desc: capitalize(petModel.size),
                                    icon: FontAwesome5Solid.ruler,
                                  ),
                                  BoxCharacteristicItem(
                                    title: "Peso",
                                    desc: "${petModel.weight}",
                                    suffix: "Kg",
                                    icon: FontAwesome5Solid.weight,
                                  ),
                                  BoxCharacteristicItem(
                                    title: "Color",
                                    desc: "${petModel.color}",
                                    icon: FontAwesome5Solid.paint_brush,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sobre mi", style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black, fontWeight: FontWeight.bold),),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text("Gato Adulto de ${petModel.age} años de edad", style: Theme.of(context).textTheme.bodyText1,),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(onPressed: () {

                        }, child: Text("Eliminar"), color: Colors.grey[100],),

                        RaisedButton(onPressed: () {

                        }, child: Text("Editar"), color: Colors.grey[300],),
                        RaisedButton(onPressed: () {

                        }, child: Text("Crear Alerta", style: TextStyle(color: Colors.white),), color: accentColor,),
                      ],
                    ),
                  ),
                )
              ]
            ),
          )
        ],
      )
    );
  }
}
