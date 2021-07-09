import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pet_alert/models/PetModel.dart';
import 'package:pet_alert/utils.dart';


class ListPetItem extends StatelessWidget {
  final PetModel petModel;

  ListPetItem({Key key,
    @required this.petModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> listColors = [ Colors.amber[700], Colors.deepOrange[600], Colors.green[500], Colors.blue, Colors.teal, Colors.lightBlue[800]];
    Random random = Random();
    Color randomColor = listColors[random.nextInt(listColors.length-1)];
    IconData iconAnimal = petModel.type == "perro" ? MaterialCommunityIcons.dog : MaterialCommunityIcons.cat;

    return GestureDetector(
      onTap: () => {
        Navigator.pushNamed(context, '/petDetail', arguments: petModel)
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
          elevation: 0,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 60,
                          margin: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: randomColor,
                            shape: BoxShape.circle
                          ),
                          child: Icon(iconAnimal, color: Colors.white, size: 40,),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                                child: Text("Mi nombre es ${petModel.name}", style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),),
                              ),
                              Text("${capitalize(petModel.type)} ${petModel.sex == 1 ? 'Macho' : 'Hembra'} de ${petModel.age} años", style: Theme.of(context).textTheme.bodyText2,),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
        ),
      )
    );
  }
}