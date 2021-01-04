import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/models/MessageModel.dart';
import 'package:pet_alert/styles.dart';
import 'package:timeago/timeago.dart' as timeago;


class ListMessageItem extends StatelessWidget {
  final MessageModel  messageModel;

  ListMessageItem({Key key,
    @required this.messageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/alertDetail', arguments: {"data": messageModel});
    },
      child: Container(
          child: Material(
            child: ListTile(
              trailing: (messageModel.owner.id == "1") ? Text(messageModel.message) : null,
              leading: (messageModel.owner.id != "1") ? Text(messageModel.message) : null,
            ),
          )
      )
    );
  }
}