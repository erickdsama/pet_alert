import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/styles.dart';
import 'package:timeago/timeago.dart' as timeago;


class ListAlertItem extends StatelessWidget {
  final AlertModel  alertModel;

  ListAlertItem({Key key,
    @required this.alertModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Map<dynamic, dynamic> pet = alertModel.pet;
    String petName = pet["name"];
    var parsedDate = DateTime.parse(alertModel.lost_date);
    String missingDate = timeago.format(parsedDate, locale: 'es');
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/alertDetail', arguments: {"data": alertModel});

    },
      child: Container(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Image.network(pet['photo'], height: 50, width: 50, fit: BoxFit.fill )
                            )
                        )
                    )
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$petName", style: titleList,),
                          Text("$missingDate", style: greyList, overflow: TextOverflow.fade, softWrap: true,),
                        ],
                      ),
                      Container( child: Text("${alertModel.description}", style: descList,))
                    ],
                  ),
                ),
              ],
            ),
          )
      )
    );
  }
}