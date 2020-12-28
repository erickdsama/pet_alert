import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_alert/models/ChatModel.dart';
import 'package:pet_alert/styles.dart';
import 'package:timeago/timeago.dart' as timeago;


class ListChatItem extends StatelessWidget {
  final ChatModel chatModel;

  ListChatItem({Key key, this.chatModel,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var parsedDate = DateTime.parse(this.chatModel.lastUpdate);
    String missingDate = timeago.format(parsedDate, locale: 'es');
    return GestureDetector(
        onTap: () {

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
                                  child: Image.network(this.chatModel.receiver.photo, height: 50, width: 50, fit: BoxFit.fill )
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
                            Text("${this.chatModel.receiver.name}", style: titleList,),
                            Text("$missingDate", style: greyList, overflow: TextOverflow.fade, softWrap: true,),
                          ],
                        ),
                        Container( child: Text("$parsedDate", style: descList,))
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