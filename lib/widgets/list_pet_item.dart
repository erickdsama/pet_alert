import 'package:couchbase_lite/couchbase_lite.dart';
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

  Database database;
  Replicator replicator;
  ListenerToken _dbListenerToken;
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