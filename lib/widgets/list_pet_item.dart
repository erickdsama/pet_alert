import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/models/PetModel.dart';
import 'package:pet_alert/styles.dart';
import 'package:pet_alert/widgets/icon_text.dart';
import 'package:timeago/timeago.dart' as timeago;


class ListPetItem extends StatelessWidget {
  final PetModel petModel;

  ListPetItem({Key key,
    @required this.petModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.pushNamed(context, '/petDetail', arguments: petModel)
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2,
            child: Column(
              children: [
                Container(
                  constraints: new BoxConstraints.expand(height: 200),
                  child: Image.network(petModel.photo, fit: BoxFit.fitWidth, width: MediaQuery.of(context).size.width,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(petModel.name, style: titleList,),
                      Icon(FontAwesome5Solid.dog)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconText(iconData: FontAwesome5Solid.dna, text: petModel.breed),
                      VerticalDivider(),
                      IconText(iconData: Ionicons.ios_color_palette, text: petModel.color),
                      VerticalDivider(),
                      IconText(iconData: (petModel.sex != 1) ? FontAwesome.mars : FontAwesome.venus, text:  (petModel.sex != 1) ? "Macho" : "Hembra" ),
                      VerticalDivider(),
                      IconText(iconData: MaterialCommunityIcons.image_size_select_small, text: petModel.size),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CupertinoButton(
                          child: Text("Crear Alerta", style: btnTextWhite,),
                          color: Colors.redAccent,
                          padding: EdgeInsets.all(8),
                          onPressed: (){
                      })

                    ],
                  ),
                )
              ],
            )
        ),
      )
    );
  }
}